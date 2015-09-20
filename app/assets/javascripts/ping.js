var Pinger = {
  seq: 0
};

// http://stackoverflow.com/a/573784
Pinger.ping = function(target, callback) {
  var start;
  var client = Pinger.client(); // xmlhttprequest object
  client.onreadystatechange = function() {
    if (client.readyState >= 2) { // request received
      lag_ms = new Date().valueOf() - start.valueOf();
      client.onreadystatechange = null; //remove handler
      callback(lag_ms);
    } 
  }

  Pinger.seq += 1;
  start = new Date();
  client.open("HEAD", target + "?" + Pinger.seq);
  client.send();
}

Pinger.client = function() {
  if (window.XMLHttpRequest)
    return new XMLHttpRequest();

  if (window.ActiveXObject)
    return new ActiveXObject('MSXML2.XMLHTTP.3.0');

  throw("No XMLHttpRequest Object Available.");
}
