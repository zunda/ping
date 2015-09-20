var Pinger = {
  seq: 0
};

// http://stackoverflow.com/a/573784
Pinger.getPing = function(target, callback) {
  var start;
  var client = Pinger.getClient(); // xmlhttprequest object
  client.onreadystatechange = function() {
    if (client.readyState >= 2) { // request received
      lag_ms = Pinger.pingDone(start); //handle ping
      client.onreadystatechange = null; //remove handler
      callback(lag_ms);
    } 
  }

  Pinger.seq += 1;
  start = new Date();
  client.open("HEAD", target + "?" + Pinger.seq);
  client.send();
}

Pinger.pingDone = function(start) {
  done = new Date();
  return done.valueOf() - start.valueOf();
}

Pinger.getClient = function() {
  if (window.XMLHttpRequest)
    return new XMLHttpRequest();

  if (window.ActiveXObject)
    return new ActiveXObject('MSXML2.XMLHTTP.3.0');

  throw("No XMLHttpRequest Object Available.");
}
