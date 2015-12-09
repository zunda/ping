task 'ping' => :environment

task :ping do
  require 'net/ping'

  %w(DATABASE_URL REDIS_URL).each do |config_var|
    url = ENV[config_var]
    next unless url
    uri = URI.parse(url)
    pinger = Net::Ping::TCP.new(uri.host, uri.port)
    if pinger.ping?
      puts "#{config_var} - #{uri.host}:#{uri.port} #{pinger.duration}"
    else
      puts "#{config_var} - #{uri.host}:#{uri.port} #{pinger.exception}"
    end
  end
end
