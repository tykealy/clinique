module Admin
  class HomeController < BaseController
    def index
      @user = current_user
      @clinic = current_clinic
    end
  end
end
