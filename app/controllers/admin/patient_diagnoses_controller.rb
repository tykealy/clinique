module Admin
  class PatientDiagnosesController < BaseController
    before_action :load_patient, only: %i[index new create]

    def index; end

    def new
      # @patient_diagnosis = @current_clinic.patient_diagnoses.new
    end

    def create
      # @patient_diagnosis = @current_clinic.patient_diagnoses.new(patient_diagnosis_params)
    end

    private

    def load_patient
      @patient = Patient.find(params[:patient_id])
    end

    # def set_patient_diagnosis
    # end

    # def patient_diagnosis_params
    #   params.require(:patient_diagnosis).permit(:patient_id, :diagnosis_id, :description)
    # end
  end
end
