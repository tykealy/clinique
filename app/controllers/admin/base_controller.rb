module Admin
  class BaseController < ApplicationController
    add_flash_types :danger, :info, :warning, :success, :messages
    before_action :authenticate_user!
    before_action :current_clinic
    attr_accessor :current_clinic

    def current_clinic
      @current_clinic ||= current_user.clinic

      if @current_clinic.nil?
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
  end
end
