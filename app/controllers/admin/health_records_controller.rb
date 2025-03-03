module Admin
  class HealthRecordsController < BaseController
    before_action :load_patient
    def index
      @health_records = @patient.health_records.includes(:health_condition)
                                .order(created_at: :desc)
    end

    def search
      search = params[:search].to_s.strip

      conditions = if search.present?
                     HealthCondition
                       .where('name ILIKE :search', search: "#{search}%")
                       .select(:name)
                       .limit(5)
                       .as_json(only: %i[name])
                   else
                     []
                   end
      render json: conditions
    end

    def value_search
      search = params[:search].to_s.strip

      condition_value = if search.present?
                          HealthRecord
                            .where('value ILIKE :search', search: "#{search}%")
                            .select(:value)
                            .limit(5)
                            .as_json(only: %i[value])
                        else
                          []
                        end
      render json: condition_value
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

      flash[:success] = I18n.t('flash.created', record: 'Health Record')
      redirect_to admin_patient_health_records_path(@patient)
    end

    def destroy
      record = @patient.health_records.find(params[:id])
      return unless record.destroy

      flash[:success] = I18n.t('flash.destroyed', record: 'Health Record')
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
