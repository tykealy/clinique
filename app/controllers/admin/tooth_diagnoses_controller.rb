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

    def edit; end

    def create
      @tooth_diagnosis = @patient_diagnosis.tooth_diagnoses.new(tooth_diagnosis_params)
      if @tooth_diagnosis.save
        flash[:success] = I18n.t('flash.created', record: @record)
      else
        flash[:danger] = I18n.t('flash.danger', record: @record)
      end
      redirect_to edit_admin_patient_patient_diagnosis_path(patient_id: @patient_diagnosis.patient_id, id: @patient_diagnosis.id)
    end

    def update; end

    def destroy
      @tooth_diagnosis = ToothDiagnosis.find(params[:id])
      @patient_diagnosis = @tooth_diagnosis.patient_diagnosis
      if @tooth_diagnosis.destroy
        flash[:success] = I18n.t('flash.destroyed', record: @record)
      else
        flash[:danger] = I18n.t('flash.danger', record: @record)
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
