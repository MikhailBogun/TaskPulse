module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update destroy]

      def index
        categories = current_user.categories.order(:name)
        render json: CategorySerializer.render(categories, root: :categories), status: :ok
      end

      def show
        render json: CategorySerializer.render_as_hash(@category), status: :ok
      end

      def create
        category = current_user.categories.create!(category_params)
        render json: CategorySerializer.render_as_hash(category), status: :created
      end

      def update
        @category.update!(category_params)
        render json: CategorySerializer.render_as_hash(@category), status: :ok
      end

      def destroy
        @category.destroy!
        head :no_content
      end

      private

      def set_category
        @category = current_user.categories.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :color)
      end
    end
  end
end
