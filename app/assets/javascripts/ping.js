// http://stackoverflow.com/a/573784
function getPing() {
  var start;
  var client = getClient(); // xmlhttprequest object
  client.onreadystatechange = function() {
    if (client.readyState >= 2) { // request received
      pingDone(start); //handle ping
      client.onreadystatechange = null; //remove handler
    } 
  }

  start = new Date();
  client.open("HEAD", "ping.js"); //static file
  client.send();
}

function pingDone(start) {
  done = new Date();
  ms = done.valueOf() - start.valueOf();
  alert(ms + " ms");
}

function getClient() {
  if (window.XMLHttpRequest)
    return new XMLHttpRequest();

  if (window.ActiveXObject)
    return new ActiveXObject('MSXML2.XMLHTTP.3.0');

  throw("No XMLHttpRequest Object Available.");
}
