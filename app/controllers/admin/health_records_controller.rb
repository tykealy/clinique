module Admin
  class HealthRecordsController < BaseController
    before_action :load_patient
    def index
      @health_records = @patient.health_records.includes(:health_condition)
                                .order(created_at: :desc)
    end

    def create
      params = health_record_params
      health_condition = HealthCondition.find_or_create_by(name: params[:health_condition_name])
      health_record = HealthRecord.new(patient_id: @patient.id,
                                       health_condition_id: health_condition.id,
                                       value: params[:value],
                                       clinic_id: @current_clinic.id
                                      )

      return unless health_record.save

      redirect_to admin_patient_health_records_path
    end

    def destroy
      record = @patient.health_records.find(params[:id])
      record.destroy
      flash[:success] = I18n.t('flash.success')

      redirect_to admin_patient_health_records_path(@patient)
    end

    private

    def health_record_params
      params.require(:health_record).permit(:patient_id, :health_condition_name, :value)
    end

    def load_patient
      @patient = Patient.find(params[:patient_id])
    end
  end
end
