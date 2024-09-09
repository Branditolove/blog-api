module Api
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
  
      private
  
      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: { message: 'Signed up successfully.', user: resource }
        else
          render json: { message: "User couldn't be created successfully.", errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end