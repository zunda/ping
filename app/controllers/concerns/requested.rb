module Requested
	extend ActiveSupport::Concern

	# Obtain IP address from http request header
	def src_addr_on_header
		 request.headers['X-Forwarded-For'] || request.headers['REMOTE_ADDR']
	end

	# Obtain HOST FQDN from http request header
	def host_on_header
		 request.headers['HTTP_HOST']
	end

	# Obtain User Agent from http request header
	def user_agent_on_header
		 request.headers['HTTP_USER_AGENT']
	end
end
