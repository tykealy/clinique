module Admin
  class HomeController < BaseController
    def index
      @user = current_user
      @clinic = current_clinic
    end

    def new; end
    def edit; end

    def create; end

    def update; end

    def destroy; end
  end
end
