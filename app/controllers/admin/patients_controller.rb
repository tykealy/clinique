module Admin
  class PatientsController < BaseController
    before_action :load_patient, only: %i[edit update destroy]
    def index
      search = params[:query].to_s.strip
      @patients = if params[:query].present?
                    Patient.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "#{search}%")
                  else
                    Patient.all
                  end
      @patients = @patients.page(params[:page]).per(15)
    end

    def new
      @patient = Patient.new
    end

    def search
      search = params[:search].to_s.strip

      patients = if search.present?
                   Patient
                     .where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "#{search}%")
                     .select(:id, :first_name, :last_name, :phone_number)
                     .limit(5)
                     .as_json(only: %i[id first_name last_name phone_number])
                 else
                   []
                 end
      render json: patients
    end

    def create
      @patient = Patient.new(patient_params)
      @patient.clinic_id = @current_clinic.id
      record = @patient.class.name
      if @patient.save!
        flash[:success] = I18n.t('flash.created', record: record)
        redirect_to admin_patients_path
      else
        flash[:danger] = I18n.t('flash.danger', record: record)
        render :new
      end
    end

    def update
      record = @patient.class.name
      if @patient.update(patient_params)
        flash[:success] = I18n.t('flash.updated', record: record)
        redirect_to admin_patients_path
      else
        flash[:danger] = I18n.t('flash.danger', record: record)
        render :edit
      end
    end

    def destroy
      @patient.destroy
      flash[:success] = I18n.t('flash.success')
      redirect_to admin_patients_path
    end

    private

    def patient_params
      params.require(:patient).permit(:first_name, :last_name, :phone_number, :email, :profile, :description, :age, :address)
    end

    def load_patient
      @patient = Patient.find(params[:id])
    end
  end
end
