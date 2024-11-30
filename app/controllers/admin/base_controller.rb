module Admin
  class BaseController < ApplicationController
    add_flash_types :danger, :info, :warning, :success, :messages
    before_action :authenticate_user!
    before_action :current_clinic

    def current_clinic
      @current_clinic ||= current_user.clinic

      return unless @current_clinic.nil?

      render file: Rails.public_path.join('404.html').to_s, status: :not_found
    end
  end
end
