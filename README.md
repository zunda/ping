# ping
[![Build Status](https://travis-ci.org/zunda/ping.svg?branch=master)](https://travis-ci.org/zunda/ping)

A Heroku app to measure latency from client to the server

## Usage
Scale - one or more `web` and `worker` needed:

```
$ heroku ps:scale web=1 worker=1
```

Schedule task to measure distance for measurements with locations delayed geocode - `rake ping_results:measure_distance`
