# app/controllers/api/v1/patients_controller.rb
module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate_user!, only: [:create]
      skip_before_action :verify_authenticity_token, only: [:create]
      def index
        @users = User.all
        render json: @users
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
