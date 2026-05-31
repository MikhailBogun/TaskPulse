module Api
  module V1
    class DashboardController < ApplicationController
      def index
        stats = fetch_dashboard_stats
        render json: stats, status: :ok
      end

      private

      def fetch_dashboard_stats
        sql = <<~SQL
          SELECT
            DATE(tl.created_at) AS day,
            c.name AS category,
            COUNT(*) FILTER (WHERE tl.status = 'success') AS success_count,
            COUNT(*) FILTER (WHERE tl.status = 'failed') AS failed_count,
            ROUND(AVG(tl.duration_seconds) FILTER (WHERE tl.status = 'success'), 2) AS avg_duration_seconds,
            SUM(COUNT(*)) OVER (
              PARTITION BY DATE(tl.created_at)
              ORDER BY c.name
            ) AS daily_running_total
          FROM task_logs tl
          LEFT JOIN tasks t ON t.id = tl.task_id
          LEFT JOIN categories c ON c.id = t.category_id
          WHERE tl.task_id IN (
            SELECT id FROM tasks WHERE user_id = #{ActiveRecord::Base.connection.quote(current_user.id)}
          )
            AND tl.created_at >= NOW() - INTERVAL '30 days'
          GROUP BY DATE(tl.created_at), c.name
          ORDER BY day DESC, category ASC
        SQL

        result = ActiveRecord::Base.connection.execute(sql)
        result.map(&:symbolize_keys)
      end
    end
  end
end
