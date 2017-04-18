namespace :test do
  task :json do
		require 'json'
		puts ARGV.inspect
		params = ARGV[-1].split(/=/, 2)[-1]
		puts params.inspect
		begin
			puts JSON.parse(params).inspect
		rescue JSON::ParserError => e
			puts e.message
		end
  end
end
