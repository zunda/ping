// http://stackoverflow.com/a/573784
function getPing(callback) {
  var start;
  var client = getClient(); // xmlhttprequest object
  client.onreadystatechange = function() {
    if (client.readyState >= 2) { // request received
      lag_ms = pingDone(start); //handle ping
      client.onreadystatechange = null; //remove handler
      callback(lag_ms);
    } 
  }

  start = new Date();
  client.open("HEAD", "ping.js"); //static file
  client.send();
}

function pingDone(start) {
  done = new Date();
  return done.valueOf() - start.valueOf();
}

function getClient() {
  if (window.XMLHttpRequest)
    return new XMLHttpRequest();

  if (window.ActiveXObject)
    return new ActiveXObject('MSXML2.XMLHTTP.3.0');

  throw("No XMLHttpRequest Object Available.");
}
