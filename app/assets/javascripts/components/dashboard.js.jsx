var MeasurementBox = React.createClass({
  loadClientLocation: function() {
    var path = "/locations/current";
    $.ajax({
      url: path,
      dataType: 'json',
      cache: true,
      success: function(data) {
        this.setState({client: data.id});
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
    this.loadClientLocation();
  },
  render: function() {
    return (
      <div className="MeasurementBox">
        Client id is {this.state.client}.
      </div>
    );
  }
});
