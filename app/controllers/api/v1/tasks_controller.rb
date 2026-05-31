module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: %i[show update destroy]

      def index
        tasks = current_user.tasks.includes(:category, :task_logs)
          .order(created_at: :desc)
          .page(params[:page])
        render json: TaskSerializer.render(tasks, root: :tasks), status: :ok
      end

      def show
        render json: TaskSerializer.render_as_hash(@task), status: :ok
      end

      def create
        task = Tasks::CreateTask.call(user: current_user, params: task_params)
        render json: TaskSerializer.render_as_hash(task), status: :created
      end

      def update
        task = Tasks::UpdateTask.call(task: @task, params: task_params)
        render json: TaskSerializer.render_as_hash(task), status: :ok
      end

      def destroy
        @task.destroy!
        head :no_content
      end

      private

      def set_task
        @task = current_user.tasks.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:name, :description, :category_id, :scheduled_at, :status)
      end
    end
  end
end
