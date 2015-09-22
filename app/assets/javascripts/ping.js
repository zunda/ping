var Pinger = {
  repeat: 5,  // must be an odd number
  interval: 500,
  results: []
};

// http://stackoverflow.com/a/573784
Pinger.ping = function(target, callback) {
  var start;
  var client = Pinger.client(); // xmlhttprequest object
  client.onreadystatechange = function() {
    if (client.readyState >= 2) { // request received
      var lag_ms = new Date().valueOf() - start.valueOf();
      client.onreadystatechange = null; //remove handler
      callback(lag_ms);
    } 
  }

  var target_ts = target + "?" + new Date().valueOf();  // to avoid cache

  start = new Date();
  client.open("HEAD", target_ts);
  client.send();
}

Pinger.client = function() {
  if (window.XMLHttpRequest)
    return new XMLHttpRequest();

  if (window.ActiveXObject)
    return new ActiveXObject('MSXML2.XMLHTTP.3.0');

  throw("No XMLHttpRequest Object Available.");
}

Pinger.measure = function(target, progress_callback, result_callback) {
  Pinger.ping(target, function(lag_ms){
    Pinger.results.push(lag_ms);
    progress_callback(lag_ms);
    if (Pinger.results.length < Pinger.repeat) {
      setTimeout(
        function(){Pinger.measure(target, progress_callback, result_callback)},
        Pinger.interval
      );
    } else {
      Pinger.results.sort();
      result_callback(Pinger.results[(Pinger.repeat - 1)/ 2]);
      Pinger.results = [];
    }
  });
}
