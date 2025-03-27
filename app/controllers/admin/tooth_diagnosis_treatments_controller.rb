module Admin
  class ToothDiagnosisTreatmentsController < BaseController
    def index; end

    def new; end

    def create
      @tooth_diagnosis_treatment = ToothDiagnosisTreatment.new(tooth_diagnosis_treatment_params)
      if @tooth_diagnosis_treatment.save
        render json: { success: true }
      else
        render json: { success: false, errors: @tooth_diagnosis_treatment.errors.full_messages }
      end
    end

    def destroy
      @tooth_diagnosis_treatment = ToothDiagnosisTreatment.find(params[:id])
      @tooth_diagnosis = @tooth_diagnosis_treatment.tooth_diagnosis
      if @tooth_diagnosis_treatment.destroy
        render json: { success: true }
      else
        render json: { success: false, errors: @tooth_diagnosis_treatment.errors.full_messages }
      end
    end

    private

    def tooth_diagnosis_treatment_params
      params.require(:tooth_diagnosis_treatment).permit(:tooth_diagnosis_id, :service_id)
    end
  end
end
