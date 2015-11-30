# ping

A Heroku app to measure latency from client to the server

[![Build Status](https://travis-ci.org/zunda/ping.svg?branch=master)](https://travis-ci.org/zunda/ping)

## Usage
Create an app on Heroku (or somewhere else), provision add-ons:

```
$ heroku addons:add heroku-postgres
$ heroku addons:add heroku-redis
$ heroku addons:add scheduler
```

Deploy, and scale - one or more `web` and `worker` are needed:

```
$ heroku ps:scale web=1 worker=1
```

Schedule task to measure distance for measurements with locations that have
delayed geocode - `rake ping_results:measure_distance`

### Debugging
Set `APP_STATUS` config var to `staging` for database access through the app.
