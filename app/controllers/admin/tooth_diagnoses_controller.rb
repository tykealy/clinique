module Admin
  class ToothDiagnosesController < BaseController
    before_action :load_patient_diagnosis, only: %i[create]

    def index
      @tooth_diagnoses = @patient_diagnosis.tooth_diagnoses
    end

    def new
      @tooth_number = params[:tooth_number]
      @patient_diagnosis_id = params[:patient_diagnosis_id]
      @tooth_diagnosis = ToothDiagnosis.new

      respond_to do |format|
        format.html { render layout: false }
        format.turbo_stream
        format.json { render json: { tooth_number: @tooth_number, patient_diagnosis_id: @patient_diagnosis_id } }
      end
    end

    def create
      @tooth_diagnosis = @patient_diagnosis.tooth_diagnoses.create!(tooth_diagnosis_params)
      record = @tooth_diagnosis.class.name
      if @tooth_diagnosis.persisted?
        redirect_to edit_admin_patient_patient_diagnosis_path(patient_id: @patient_diagnosis.patient_id, id: @patient_diagnosis.id)
        flash[:success] = I18n.t('flash.created', record: record)
      else
        flash[:danger] = I18n.t('flash.danger', record: record)
      end
    end

    private

    def load_patient_diagnosis
      @patient_diagnosis = PatientDiagnosis.find(params[:patient_diagnosis_id])
    end

    def tooth_diagnosis_params
      params.require(:tooth_diagnosis).permit(:tooth_number, :patient_diagnosis_id, :diagnosis_id)
    end
  end
end
