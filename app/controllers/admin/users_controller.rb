module Admin
  class UsersController < BaseController
    def index
      @user = current_user
      @clinic = current_clinic
    end

    # def create
    #   user = User.new(user_params)
    #   if user.save
    #     render json: user, status: :created
    #   else
    #     render json: user.errors, status: :unprocessable_entity
    #   end
    # end

    # def user_params
    #   params.require(:user).permit(:email, :password)
    # end
  end
end
