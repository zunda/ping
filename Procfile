web: trap '' SIGTERM; puma -C config/puma.rb & TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE=\* rake resque:work & wait -n; kill -SIGTERM -$$; wait
release: rake db:migrate
