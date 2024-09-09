class ApplicationController < ActionController::API
    private
    def index
      @posts = Post.all
      render json: @posts
    end
  
    def authenticate_user!
      token = request.headers['Authorization'].to_s.split(' ').last
      begin
        decoded = JWT.decode(token, Rails.application.credentials.secret_key_base).first
        @current_user = User.find(decoded['user_id'])
      rescue JWT::DecodeError
        render json: { errors: ['Invalid token'] }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['User not found'] }, status: :unauthorized
      end
    end
  end