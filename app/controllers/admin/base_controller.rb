module Admin
  class BaseController < ApplicationController
    add_flash_types :danger, :info, :warning, :success, :messages
    before_action :authenticate_user!
    before_action :current_clinic
    before_action :load_appointment_count, except: %i[create update destroy]
    before_action :load_record, except: %i[index edit new]

    def current_clinic
      @current_clinic ||= current_user.clinics.first

      return unless @current_clinic.nil?

      render file: Rails.public_path.join('404.html').to_s, status: :not_found
    end

    def load_appointment_count
      @today_appointment_count ||= Appointment.for_clinic(@current_clinic).confirmed_for_date(Time.zone.today).count
    end

    protected

    def load_record
      @record = if model_exists?
                  controller_name.classify.constantize.model_name.human
                else
                  controller_name.humanize
                end
    end

    private

    def model_exists?
      controller_name.classify.constantize
      true
    rescue NameError
      false
    end

    def model_class
      controller_name.classify.constantize
    end

    def record_name
      model_class.model_name.human
    end
  end
end
