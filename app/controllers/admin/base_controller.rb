module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    attr_accessor :current_clinic

    def current_clinic
      @current_clinic ||= current_user.clinic
    end
  end
end
