class RecipesController < ApplicationController
    before_action :authorize

    def index
        recipes = Recipe.all
        render json: recipes, status: :created, include: [:user]
    end

    def create
        user = User.find(session[:user_id])
        recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created, include: [:user]
        rescue ActiveRecord::RecordInvalid => e
            render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end

    private

    def authorize
        render json: {errors: ["Not logged in"]}, status: :unauthorized unless session.include? :user_id
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end
end
