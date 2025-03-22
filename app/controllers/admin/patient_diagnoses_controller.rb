module Admin
  class PatientDiagnosesController < BaseController
    before_action :load_patient, only: %i[index edit create]

    def index
      @patient_diagnoses = @patient.patient_diagnoses
    end

    def create
      @patient_diagnosis = PatientDiagnosis.create(patient_id: params[:patient_id], clinic_id: @current_clinic.id)
      record = @patient_diagnosis.class.name

      if @patient_diagnosis.persisted?
        redirect_to edit_admin_patient_patient_diagnosis_path(patient_id: @patient.id, id: @patient_diagnosis.id)
        flash[:success] = I18n.t('flash.created', record: record)
      else
        flash[:danger] = I18n.t('flash.danger', record: record)
      end
    end

    private

    def load_patient
      @patient = Patient.find(params[:patient_id])
    end
  end
end
