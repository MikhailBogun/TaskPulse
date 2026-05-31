module Api
  module V1
    module Subscriptions
      class PortalsController < ApplicationController
        def create
          result = ::Subscriptions::CreateBillingPortalSession.call(user: current_user)
          render json: result, status: :ok
        end
      end
    end
  end
end
