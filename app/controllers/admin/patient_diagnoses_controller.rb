module Admin
  class PatientDiagnosesController < BaseController
    before_action :load_patient, only: %i[index edit create update]
    before_action :load_patient_diagnosis, only: %i[edit update]
    before_action :load_tooth_diagnosis, only: %i[edit]
    before_action :load_services, only: %i[edit]
    before_action :load_diagnosed_teeth, only: %i[edit]
    before_action :load_diagnosis, only: %i[edit]
    def index
      @patient_diagnoses = @patient.patient_diagnoses
                                   .select('patient_diagnoses.*,
                 COUNT(DISTINCT tooth_diagnoses.tooth_number) as total_diagnosed_teeth,
                 COUNT(DISTINCT tooth_diagnosis_treatments.id) as total_treatments'
                                          )
                                   .left_joins(:tooth_diagnoses, :tooth_diagnosis_treatments)
                                   .group('patient_diagnoses.id')

      # Preload distinct tooth numbers in a single query
      tooth_numbers = ToothDiagnosis
                      .select(:patient_diagnosis_id, :tooth_number)
                      .distinct
                      .where(patient_diagnosis_id: @patient_diagnoses.map(&:id))
                      .group_by(&:patient_diagnosis_id)

      # Attach the preloaded data to each patient_diagnosis
      @patient_diagnoses.each do |pd|
        pd.instance_variable_set(:@tooth_numbers, tooth_numbers[pd.id] || [])
        pd.define_singleton_method(:tooth_numbers) { @tooth_numbers }
      end
    end

    def new; end

    def edit
      @patient = @patient_diagnosis.patient
      @services = Service.all
    end

    def create
      @patient_diagnosis = PatientDiagnosis.new(patient_id: params[:patient_id], clinic_id: @current_clinic.id)

      if @patient_diagnosis.save
        redirect_to edit_admin_patient_patient_diagnosis_path(patient_id: @patient.id, id: @patient_diagnosis.id)
        flash[:success] = I18n.t('flash.created', record: @record)
      else
        flash[:danger] = I18n.t('flash.danger', record: @record)
      end
    end

    def update
      if @patient_diagnosis.update(patient_diagnosis_params)
        redirect_to edit_admin_patient_patient_diagnosis_path(patient_id: @patient.id, id: @patient_diagnosis.id)
        flash[:success] = I18n.t('flash.updated', record: @record)
      else
        flash[:danger] = I18n.t('flash.danger', record: @record)
      end
    end

    def destroy; end

    private

    def load_patient
      @patient = Patient.find(params[:patient_id])
    end

    def load_patient_diagnosis
      @patient_diagnosis ||= PatientDiagnosis.find(params[:id])
    end

    def load_tooth_diagnosis
      @tooth_diagnosis = ToothDiagnosis.new
    end

    def load_diagnosis
      @diagnosis = Diagnosis.where(status: true)
    end

    def load_services
      @services = Service.all
    end

    def load_diagnosed_teeth
      @diagnosed_teeth = ToothDiagnosesQuery.new(@patient_diagnosis.id).fetch_tooth_diagnoses
    end

    def patient_diagnosis_params
      params.require(:patient_diagnosis).permit(:description)
    end
  end
end
