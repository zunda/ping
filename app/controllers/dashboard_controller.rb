class DashboardController < ApplicationController
  def index
    logger.info "X-Forwarded-For: #{request.headers['X-Forwarded-For'].inspect}"
    logger.info "request.remote_ip: #{request.remote_ip.inspect}"
  end
end
