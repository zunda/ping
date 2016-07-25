class LoaderioController < ActionController::Base  
  def verify
		if "loaderio-#{params[:id]}" == ENV['LOADERIO_VERIFICATION_FILENAME']
			send_data token, :type => "text/plain", :disposition => "inline" 
		else
			raise ActionController::RoutingError.new('Not Found')
		end
  end

  private

  def token
    "loaderio-#{ENV['LOADERIO_VERIFICATION_TOKEN']}"
  end
end  
