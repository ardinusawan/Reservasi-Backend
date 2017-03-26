class HomeController < ApplicationController
  #before_filter :authenticate_request!

  def index
    #render json: {'logged_in' => true}
    render :file => 'public/index.html'
  end

  # Start of CORS header
  def create
    if access_allowed?
      set_access_control_headers
      head :created
    else
      head :forbidden
    end
  end

  def options
    if access_allowed?
      set_access_control_headers
      head :ok
    else
      head :forbidden
    end
  end

  private
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PATCH'
    headers['Access-Control-Max-Age'] = '1728000'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with, Content-Type, Accept, Authorization'
    # headers['Access-Control-Allow-Headers'] = 'Authorization'
    # headers['Access-Control-Allow-Headers'] = 'Content-Type'
  end

  # HTTP_ORIGIN
  def access_allowed?
    allowed_sites = [request.env['HTTP_ORIGIN']] #you might query the DB or something, this is just an example
    return allowed_sites.include?(request.env['HTTP_ORIGIN'])
  end
  # End of CORS header
end
