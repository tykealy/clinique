module Admin
  class DiagnosesController < BaseController
    before_action :set_diagnosis, only: %i[edit update destroy toggle_status]

    def index
      @diagnoses = if params[:query].present?
                     @current_clinic.diagnoses.where('name ILIKE ?', "%#{params[:query]}%").order(status: :desc).page(params[:page]).per(10)
                   else
                     @current_clinic.diagnoses.order(status: :desc).page(params[:page]).per(10)
                   end
    end

    def new
      @diagnosis = Diagnosis.new
    end

    def edit; end

    def create
      @diagnosis = @current_clinic.diagnoses.new(diagnosis_params)
      if @diagnosis.save
        flash[:success] = I18n.t('flash.created', record: @diagnosis.class.name)
        redirect_to admin_diagnoses_path
      else
        flash[:danger] = I18n.t('flash.danger', record: @diagnosis.class.name)
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @diagnosis.update(diagnosis_params)
        flash[:success] = I18n.t('flash.updated', record: @diagnosis.class.name)
        redirect_to admin_diagnoses_path
      else
        flash[:danger] = I18n.t('flash.danger', record: @diagnosis.class.name)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy; end

    def toggle_status
      new_status = @diagnosis.active? ? :inactive : :active
      if @diagnosis.update(status: new_status)
        flash[:success] = I18n.t('flash.updated', record: @diagnosis.class.name)
      else
        flash[:danger] = I18n.t('flash.danger', record: @diagnosis.class.name)
      end
      redirect_to admin_diagnoses_path
    end

    private

    def set_diagnosis
      @diagnosis = @current_clinic.diagnoses.find(params[:id])
    end

    def diagnosis_params
      params.require(:diagnosis).permit(:name, :code, :description, :status)
    end
  end
end
