class ApplicationController < ActionController::API
  include ActionController::Serialization
# Start of Auth
  attr_reader :current_user

  protected
  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  # End of Auth

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
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = '1728000'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with'
  end

  # HTTP_ORIGIN
  def access_allowed?
    allowed_sites = [request.env['HTTP_ORIGIN']] #you might query the DB or something, this is just an example
    return allowed_sites.include?(request.env['HTTP_ORIGIN'])
  end
  # End of CORS header

  # Start of Auth
  def http_token
    @http_token ||= if request.headers['Authorization'].present?
                      request.headers['Authorization'].split(' ').last
                    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
  # End of Auth
end
