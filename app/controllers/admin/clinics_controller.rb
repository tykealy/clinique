module Admin
  class ClinicsController < BaseController
    before_action :load_clinic, only: %i[edit update]
    def index; end

    def edit
      # @current_clinic = Clinic.find(params[:id])
    end

    def update
      if @current_clinic.update(clinic_params)
        flash[:success] = I18n.t('flash.success')
      else
        flash[:danger] = I18n.t('flash.danger')
      end
      redirect_to edit_admin_clinic_path(@current_clinic)
    end

    private

    def load_clinic
      @current_clinic = Clinic.find(params[:id])
    end

    def clinic_params
      params.require(:clinic).permit(:name, :address, :phone, :logo, :email, :website,
                                     :description, :status
      )
    end
  end
end
