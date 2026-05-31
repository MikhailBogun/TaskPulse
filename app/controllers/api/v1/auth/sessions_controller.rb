module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: {
            user: UserSerializer.render_as_hash(resource),
            token: request.env["warden-jwt_auth.token"]
          }, status: :ok
        end

        def respond_to_on_destroy
          if current_user
            render json: { message: "Logged out successfully" }, status: :ok
          else
            render json: { error: "No active session" }, status: :unauthorized
          end
        end
      end
    end
  end
end
