# ping

A Heroku app to measure latency from client to the server

[![Build Status](https://travis-ci.org/zunda/ping.svg?branch=master)](https://travis-ci.org/zunda/ping)

## Usage
Deploy and open the top page of the app.

### Via Heroku button
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Click the Deloy to Heroku button, then migrate the database,
and scale the `worker`:

```
$ heroku run rake db:migrate
$ heroku ps:scale worker=1
```

Schedule a task, say hourly, on Heroku Scheduler to sweep database for delayed execution of geocoding locations and measuring distances

```
rake locations:geocode ping_results:measure_distance
```

### Via CLI
Alternatively, create an app on Heroku (or somewhere else), push,
and provision add-ons:

```
$ heroku create <app-name>
$ heroku addons:create heroku-postgresql
$ heroku addons:create heroku-redis
$ heroku addons:create scheduler
$ git push heroku master
```

Migrate the database, and scale - one or more `web` and `worker` are needed:

```
$ heroku run rake db:migrate
$ heroku ps:scale web=1 worker=1
```

Schedule a task, say hourly, on Heroku Scheduler to sweep database for delayed execution of geocoding locations and measuring distances

```
rake locations:geocode ping_results:measure_distance
```

### Debugging
Set `APP_STATUS` config var to `staging` for database access through the app.

## Measurement
This program measures time needed to receive response for a `HEAD` request
to one of its static assets.
See the [Javascript code](app/assets/javascripts/ping.js) for details.

The time measured should be for  a round trip of packets between
the client and the server.
A `tcpudmp` shows something like below for each ping.

```
08:11:30.340923 IP misoan.51404 > ec2-54-243-156-39.compute-1.amazonaws.com.http: Flags [P.], seq 2347:3100, ack 2835, win 296, length 753
08:11:30.477844 IP ec2-54-243-156-39.compute-1.amazonaws.com.http > misoan.51404: Flags [P.], seq 2835:3052, ack 3100, win 96, length 217
08:11:30.477929 IP misoan.51404 > ec2-54-243-156-39.compute-1.amazonaws.com.http: Flags [.], ack 3052, win 314, length 0
```

## Samples
- http://ping-us.herokuapp.com/
- http://ping-eu.herokuapp.com/
- http://ping-tokyo.herokuapp.com/
