# app/controllers/api/v1/patients_controller.rb
module Api
  module V1
    class PatientsController < BaseController
      def index
        @patients = { patients: "asf" }
        render json: @patients
      end
    end
  end
end
