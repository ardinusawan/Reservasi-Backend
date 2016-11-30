class ApplicationController < ActionController::API
#   before_filter :cors_preflight_check
#   after_filter :cors_set_access_control_headers
#
# # For all responses in this controller, return the CORS access control headers.
#
#   def cors_set_access_control_headers
#     headers['Access-Control-Allow-Origin'] = '*'
#     headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
#     headers['Access-Control-Max-Age'] = "1728000"
#   end
#
# # If this is a preflight OPTIONS request, then short-circuit the
# # request, return only the necessary headers and return an empty
# # text/plain.
#
#   def cors_preflight_check
#     if request.method == :options
#       headers['Access-Control-Allow-Origin'] = '*'
#       headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
#       headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
#       headers['Access-Control-Max-Age'] = '1728000'
#       render :text => '', :content_type => 'text/plain'
#     end
#   end

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
    headers['Access-Control-Allow-Origin'] = request.env['http://ardinusawan.id']
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = '1000'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with'
  end

  # HTTP_ORIGIN
  def access_allowed?
    allowed_sites = [request.env['http://ardinusawan.id']] #you might query the DB or something, this is just an example
    return allowed_sites.include?(request.env['http://ardinusawan.id'])
  end
end
