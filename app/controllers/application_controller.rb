class ApplicationController < ActionController::API
  before_action :require_authorization! #, except: [....]

  def require_authorization!
    return true if authorized
    render json: { errors: [
                            {
                              status: "unauthorized",
                              code: "401",
                              title: "Access denied",
                              details: ""
                            }]
                  }, status: :unauthorized
  end

  private
    def authorized
      token = request.headers['Authorization'].sub('Bearer ','')
      decoded_token = JWT.decode token, Rails.application.credentials.jwt[:secret_key], true, { algorithm: Rails.application.credentials.jwt[:algorithm] }
      return User.exists?(email: decoded_token.first["email"], password: decoded_token.first["password"])
    end
end
