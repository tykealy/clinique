module Admin
  class ClinicsController < BaseController
    before_action :load_clinic, only: [ :edit, :update ]
    def index
    end
    def edit
      @current_clinic = Clinic.find(params[:id])
    end

    def update
      if @current_clinic.update(clinic_params)
      flash[:success] = "Clinic updated successfully"
      else
      flash[:danger] = "Clinic update failed"
      end
      redirect_to edit_admin_clinic_path(@current_clinic)
    end

    private
    def load_clinic
      @current_clinic = Clinic.find(params[:id])
    end
    def clinic_params
      params.require(:clinic).permit(:name, :address, :phone, :logo, :email, :website, :description, :status)
    end
  end
end
