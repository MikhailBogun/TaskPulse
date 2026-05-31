module Api
  module V1
    class AlertRulesController < ApplicationController
      before_action :set_alert_rule, only: %i[show update destroy]

      def index
        rules = current_user.alert_rules.order(created_at: :desc)
        render json: AlertRuleSerializer.render(rules, root: :alert_rules), status: :ok
      end

      def show
        render json: AlertRuleSerializer.render_as_hash(@alert_rule), status: :ok
      end

      def create
        rule = current_user.alert_rules.create!(alert_rule_params)
        render json: AlertRuleSerializer.render_as_hash(rule), status: :created
      end

      def update
        @alert_rule.update!(alert_rule_params)
        render json: AlertRuleSerializer.render_as_hash(@alert_rule), status: :ok
      end

      def destroy
        @alert_rule.destroy!
        head :no_content
      end

      private

      def set_alert_rule
        @alert_rule = current_user.alert_rules.find(params[:id])
      end

      def alert_rule_params
        params.require(:alert_rule).permit(:name, :rule_type, :condition, :threshold, :notification_channel, :active)
      end
    end
  end
end
