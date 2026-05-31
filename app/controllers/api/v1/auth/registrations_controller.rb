module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        skip_before_action :authenticate_user!

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              user: UserSerializer.render_as_hash(resource),
              message: "Registration successful. Please check your email to confirm your account."
            }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
