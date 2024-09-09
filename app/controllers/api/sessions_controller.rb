require 'jwt'

class Api::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_signed_out_user, only: :destroy

  def create
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      token = generate_jwt_token(user)
      render json: { token: token, email: user.email }
    else
      render json: { errors: ['Invalid Email or password'] }, status: :unauthorized
    end
  end

  def destroy
    if current_user
 
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { message: 'No active session' }, status: :unauthorized
    end
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  def generate_jwt_token(user)
    JWT.encode({ user_id: user.id, exp: 60.days.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end

  def current_user
   
    header = request.headers['Authorization']
    return nil if header.nil?
    
    token = header.split(' ').last
    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      User.find(decoded.first['user_id'])
    rescue JWT::DecodeError
      nil
    end
  end
end