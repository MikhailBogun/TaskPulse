module Api
  module V1
    module Auth
      class UsersController < ApplicationController
        def me
          render json: UserSerializer.render_as_hash(current_user), status: :ok
        end
      end
    end
  end
end
