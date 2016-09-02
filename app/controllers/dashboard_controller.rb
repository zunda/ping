class DashboardController < ApplicationController
  def index
    logger.info "X-Forwarded-For: #{request.headers['X-Forwarded-For'].inspect}"
  end
end
