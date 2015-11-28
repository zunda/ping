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
        <ServerBox />
        <ClientBox />
      </div>
    );
  }
});

var ClientBox = React.createClass({
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
      <div className="clientBox">
        Your are at {city}.
      </div>
    );
  }
});

var ServerBox = React.createClass({
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
      <div className="serverBox">
        Ping the server at {city}!
      </div>
    );
  }
});
