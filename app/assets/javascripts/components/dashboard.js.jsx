var MeasurementBox = React.createClass({
  interval: 2000,
  loadLocation: function(path, propPrefix) {
    $.ajax({
      url: path,
      dataType: 'json',
      cache: true,
      success: function(data) {
        if (data.city) {
          var newState = {};
          newState[propPrefix + "Id"] = data.id;
          newState[propPrefix + "City"] = data.city;
          this.setState(newState);
        } else {
          setTimeout(loadLocation.bind(this), this.interval, path, propPrefix);
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(path, status, err.toString());
      }.bind(this)
    });
  },

  getInitialState: function() {
    return {};
  },
  componentDidMount: function() {
    this.loadLocation("/locations/current", "client");
    this.loadLocation("/locations/server", "server");
  },

  render: function() {
    return (
      <div className="measurementBox">
        <p>
        Ping the server at <ServerCity city={this.state.serverCity} /> from <ClientCity city={this.state.clientCity} />!
        </p>
        <PingBox serverId={this.state.serverId} clientId={this.state.clientId} />
      </div>
    );
  }
});

var ClientCity = React.createClass({
  render: function() {
    var city = this.props.data;
    if (!city) {
      city = "unknown location";
    }
    return (
      <span className="clientCity">{city}</span>
    );
  }
});

var ServerCity = React.createClass({
  render: function() {
    var city = this.props.data;
    if (!city) {
      city = "unknown location";
    }
    return (
      <span className="serverCity">{city}</span>
    );
  }
});

var PingBox = React.createClass({
  render: function() {
    var serverId = this.props.serverId;
    var clientId = this.props.clientId;
    return (
      <div className="PingBox">Pinging from location id:{clientId} to id:{serverId}</div>
    );
  }
});
