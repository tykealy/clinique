module Admin
  class DoctorsController < BaseController
    before_action :load_doctor, only: %i[edit update]
    def index
      @doctors = Doctor.all
    end

    def new
      @doctor = Doctor.new
    end

    def create
      @doctor = Doctor.new(doctor_params)
      @doctor.clinic_id = @current_clinic.id

      if @doctor.save
        flash[:success] = I18n.t('flash.success')
        redirect_to admin_doctors_path
      else
        flash[:danger] = I18n.t('flash.danger')
        render :new
      end
    end

    def update
      if @doctor.update(doctor_params)
        flash[:success] = I18n.t('flash.success')
        redirect_to admin_doctors_path
      else
        flash[:danger] = I18n.t('flash.danger')
        render :edit
      end
    end

    def destroy
      @doctor = Doctor.find(params[:id])
      @doctor.destroy
      flash[:success] = I18n.t('flash.success')
      redirect_to admin_doctors_path
    end

    private

    def load_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:first_name, :last_name, :phone_number, :email, :address, :age, :profile, :description,
                                     preferences: %i[bg_color font_color]
      )
    end
  end
end
