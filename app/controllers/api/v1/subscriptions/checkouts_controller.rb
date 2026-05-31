module Api
  module V1
    module Subscriptions
      class CheckoutsController < ApplicationController
        def create
          result = ::Subscriptions::CreateCheckoutSession.call(
            user: current_user,
            plan: params.require(:plan)
          )
          render json: result, status: :ok
        rescue ArgumentError => e
          render json: { error: e.message }, status: :bad_request
        end
      end
    end
  end
end
