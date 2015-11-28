var loadLocation = function(path) {
  $.ajax({
    url: path,
    dataType: 'json',
    cache: true,
    success: function(data) {
      this.setState({id: data.id, city: data.city});
    }.bind(this),
    error: function(xhr, status, err) {
      console.error(path, status, err.toString());
    }.bind(this)
  });
};

var MeasurementBox = React.createClass({
  render: function() {
    return (
      <div className="measurementBox">
        Ping the server at <ServerCity /> from <ClientCity />!
      </div>
    );
  }
});

var ClientCity = React.createClass({
  getInitialState: function() {
    return {};
  },
  componentDidMount: function() {
    loadLocation.call(this, "/locations/current");
  },

  render: function() {
    var city = this.state.city;
    if (!city) {
      city = "unknown location";
    }
    return (
      <span className="clientCity">{city}</span>
    );
  }
});

var ServerCity = React.createClass({
  getInitialState: function() {
    return {};
  },
  componentDidMount: function() {
    loadLocation.call(this, "/locations/server");
  },

  render: function() {
    var city = this.state.city;
    if (!city) {
      city = "unknown location";
    }
    return (
      <span className="serverCity">{city}</span>
    );
  }
});
