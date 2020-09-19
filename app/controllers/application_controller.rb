class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  
  def json_response(json, success: true)
    render(
      json: { 
        success: success
      }.merge(json)
    )
  end
end
