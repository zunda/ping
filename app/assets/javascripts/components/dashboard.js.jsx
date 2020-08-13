var MeasurementBox = React.createClass({
  locationInterval: 2000,
  resultInterval: 600000,
  loadLocation: function(path, propPrefix) {
    $.ajax({
      url: path,
      dataType: 'json',
      cache: true,
      success: function(data) {
        var newState = {};
        newState[propPrefix + "Id"] = data.id;
        newState[propPrefix + "City"] = data.city;
        newState[propPrefix + "CityError"] = null;
        this.setState(newState);
        if (!data.city) { // retry until we get the city
          setTimeout(this.loadLocation, this.locationInterval, path, propPrefix);
        }
      }.bind(this),
      error: function(xhr, status, err) {
        var errString = err.toString();
        var newState = {};
        newState[propPrefix + "CityError"] = errString;
        this.setState(newState);
        console.error(status, errString);
      }.bind(this)
    });
  },
  loadResults: function() {
    $.ajax({
      url: "/ping_results/recent",
      dataType: 'json',
      cache: true,
      success: function(data) {
        this.setState({recentResults: data ,resultsError: null});
        setTimeout(this.loadResults, this.resultInterval);
      }.bind(this),
      error: function(xhr, status, err) {
        var errString = err.toString();
        this.setState({resultsError: errString});
        console.error(status, errString);
        setTimeout(this.loadResults, this.resultInterval);
      }.bind(this)
    });
  },

  getInitialState: function() {
    return {
      serverCity: "(looking up)",
      serverCityError: null,
      clientCity: "(looking up)",
      clientCityError: null,
      recentResults: [],
      myResults: [],
      resultsError: null
    };
  },
  componentDidMount: function() {
    this.loadLocation("/locations/current", "client");
    this.loadLocation("/locations/server", "server");
    this.loadResults();
  },

  render: function() {
    return (
      <div className="measurementBox">
        <p>Ping the server at <ServerCity city={this.state.serverCity} /> from <ClientCity city={this.state.clientCity} />!</p>
        <DataFetchError
          server={this.state.serverCityError}
          client={this.state.clientCityError}
          results={this.state.resultsError}
        />
        <PingBox
          serverId={this.state.serverId}
          clientId={this.state.clientId}
          recentResults={this.state.recentResults}
          myResults={this.state.myResults}
          target={this.props.target}
        />
      </div>
    );
  }
});

var DataFetchError = React.createClass({
  render: function() {
    var message = ""
    if (this.props.server || this.props.client) {
      message = "Error in fetching";
    }
    if (this.props.server) {
      message += " - server location: " + this.props.server;
    }
    if (this.props.client) {
      message += " - client location: " + this.props.client;
    }
    if (this.props.results) {
      message += " - recent results: " + this.props.results;
    }
    return (
      <div className="dataFetchError">{message}</div>
    );
  }
})

var ClientCity = React.createClass({
  render: function() {
    var city = this.props.city || "(looking up)";
    return (
      <span className="clientCity">{city}</span>
    );
  }
});

var ServerCity = React.createClass({
  render: function() {
    var city = this.props.city || "(looking up)";
    return (
      <span className="serverCity">{city}</span>
    );
  }
});

var ping = {
  pingButton: "Ping",
  pingingButton: "......",
  postButton: "Post",
  result: null,
  serverId: null,
  clientId: null
};

var PingBox = React.createClass({
  getInitialState: function() {
    return {
      buttonValue: ping.pingButton,
      buttonDisabled: false,
      resultValue: "",
      progressValue: "",
      error: null
    };
  },
  handleSubmit: function(e) {
    e.preventDefault();
    if (this.state.buttonValue == ping.pingButton) {
      var ping_progress = "";
      this.setState({
        buttonValue: ping.pingingButton,
        buttonDisabled: true,
        resultValue: "",
        progressValue: ping_progress
      });
      Pinger.measure.call(this,
        this.props.target,
        function(lag){
          ping_progress = ping_progress + " " + lag;
          this.setState({progressValue: ping_progress});
        }.bind(this),
        function(lag){
          ping.result = lag;
          this.setState({
            buttonValue: ping.postButton,
            buttonDisabled: false,
            resultValue: lag
          });
        }.bind(this)
      );
    } else if (this.state.buttonValue == ping.postButton) {
      $.ajax({
        url: "/ping_results",
        type: "POST",
        dataType: 'json',
        cache: false,
        data: {
          ping_result: {
            lag_ms: ping.result,
            location_id: ping.clientId,
            server_location_id: ping.serverId
          }
        },
        success: function(data) {
          var myResults = this.props.myResults;
          var d = data.distance_km;
          if (d) {
            myResults.push({lag_ms: data.lag_ms, distance_km: d});
          }
          this.setState({
            buttonValue: ping.pingButton,
            resultValue: "",
            progressValue: "",
            error: null,
            myResults: myResults
          });
        }.bind(this),
        error: function(xhr, status, err) {
          var errorString = err.toString();
          this.setState({error: errorString});
          console.error(status, errorString);

        }.bind(this)
      });
    };
  },
  render: function() {
    ping.serverId = this.props.serverId;
    ping.clientId = this.props.clientId;
    var recentResults=this.props.recentResults;
    var myResults=this.props.myResults;
    return (
      <div>
        <form className="PingBox" onSubmit={this.handleSubmit}>
          <input type="submit" id="button" value={this.state.buttonValue} disabled={this.state.buttonDisabled} />
          <input type="text" placeholder="Median" id="ping_result_lag_ms" value={this.state.resultValue} size="5" readOnly />
          <input type="text" placeholder="Progress" id="ping_progress" value={this.state.progressValue} size="24" readOnly />
          msec
        </form>
      <PingResultError error={this.state.error} />
      <PlotBox
        recentResults={recentResults}
        myResults={myResults}
      />
      </div>
    );
  }
});

var PingResultError = React.createClass({
  render: function() {
    var error = "";
    if (this.props.error) {
      error = "Problem in sending the result: " + this.props.error + ". Please reload and retry."
    }
    return (
      <div className="pingResultError">{error}</div>
    );
  }
});

var PlotBox = React.createClass({
  render: function() {
    var data = [];
    if (this.props.recentResults && this.props.recentResults.length > 0) {
      data.push({label: 1, values: this.props.recentResults});
    }
    if (this.props.myResults && this.props.myResults.length > 0) {
      data.push({label: 2, values: this.props.myResults});
    }
    
    if (data.length > 0) {
      var ScatterPlot = ReactD3.ScatterPlot;
      var colorScale = d3.scale.category10();
      var xAccessor = function(e){return e.distance_km;};
      var yAccessor = function(e){return e.lag_ms;};
      return(
        <div className="plotBox"><ScatterPlot
          data={data}
          width={640}
          height={400}
          x={xAccessor}
          y={yAccessor}
          colorScale={colorScale}
          xAxis={{label: "Distance (km)"}}
          yAxis={{label: "Lag (msec)"}}
          margin={{top: 20, bottom: 20, left: 40, right: 20}}
        /></div>
      );
    } else {
      return(
        <div className="plotBox" />
      );
    }
  }
});
