require 'resque/tasks'
require 'resque_scheduler/tasks'

task 'resque:setup' => :environment
namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
  end
end
