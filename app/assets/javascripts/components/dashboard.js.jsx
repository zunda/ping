var MeasurementBox = React.createClass({
  loadLocation: function(path, prop) {
    var state = new Object();
    $.ajax({
      url: path,
      dataType: 'json',
      cache: true,
      success: function(data) {
        state[prop] = data.id
        this.setState(state);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(path, status, err.toString());
      }.bind(this)
    });
  },
  loadClientLocation: function() {
    this.loadLocation("/locations/current", 'client');
  },
  loadServerLocation: function() {
    this.loadLocation("/locations/server", 'server');
  },

  getInitialState: function() {
    return {};
  },
  componentDidMount: function() {
    this.loadClientLocation();
    this.loadServerLocation();
  },
  render: function() {
    return (
      <div className="measurementBox">
        Client id is {this.state.client}.
        <ServerBox data={this.state.server} />
      </div>
    );
  }
});

var ServerBox = React.createClass({
  render: function() {
    return (
      <div className="serverBox">
        Server id is {this.props.data}.
      </div>
    );
  }
});
