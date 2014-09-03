class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Rack::Timeout::RequestTimeoutError,
              Rack::Timeout::RequestExpiryError,
              with: :handle_request_timeout

  private

  def handle_request_timeout(_)
    # If there is no accepted format declared by controller
    respond_to do |format|
      format.html do
        render file: Rails.root.join("public/503.html"),
          status: 503, layout: nil
      end
      format.all  { head 503 }
    end
  end
end
