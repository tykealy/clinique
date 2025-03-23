module Admin
  class PatientDiagnosesController < BaseController
    before_action :load_patient, only: %i[index edit create]
    before_action :load_tooth_diagnosis, only: %i[edit]
    before_action :load_services, only: %i[edit]

    def index
      @patient_diagnoses = @patient.patient_diagnoses
    end

    def edit
      @patient_diagnosis = PatientDiagnosis.find(params[:id])
      @patient = @patient_diagnosis.patient

      # Fetch all tooth diagnoses for this patient diagnosis and group by tooth number
      @tooth_diagnoses_by_tooth = ToothDiagnosesQuery.new(@patient_diagnosis.id).fetch_tooth_diagnoses
    end

    def create
      @patient_diagnosis = PatientDiagnosis.new(patient_id: params[:patient_id], clinic_id: @current_clinic.id)
      record = @patient_diagnosis.class.name

      if @patient_diagnosis.save
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

    def load_tooth_diagnosis
      @tooth_diagnosis = ToothDiagnosis.new
    end

    def load_services
      @services = Service.all
    end
  end
end
