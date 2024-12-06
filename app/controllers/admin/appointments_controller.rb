module Admin
  class AppointmentsController < BaseController
    before_action :load_doctors
    def index
      query = Admin::AppointmentQuery.new(Time.zone.today - 6.days, @current_clinic.id)
      @appointments = query.fetch_appointments_for_week
      @dates = query.weekdates
    end

    def show
      @appointment = Appointment.find(params[:id])
      render partial: 'appointment_card', locals: { appointment: @appointment }
    end

    def new
      @appointment = Appointment.new
      render partial: 'new', locals: { appointment: @appointment }
    end

    def edit
      @appointment = Appointment.find(params[:id])
      render partial: 'edit', locals: { appointment: @appointment }
    end

    def create
      date = appointment_params[:date]
      time = appointment_params[:time_hour]
      @appointment = Appointment.new(appointment_params.except(:time_hour))
      @appointment.date = combine_date_time(date, time)
      @appointment.clinic_id = @current_clinic.id
      if @appointment.save
        flash[:success] = I18n.t('flash.success')
        redirect_to admin_appointments_path
      else
        flash[:danger] = I18n.t('flash.danger')
        render :new
      end
    end

    def update
      @appointment = Appointment.find(params[:id])
      date = appointment_params[:date]
      time = appointment_params[:time_hour]
      combined_date_time = combine_date_time(date, time)
      if @appointment.update(appointment_params.except(:time_hour))
        @appointment.update(date: combined_date_time)
        flash[:success] = I18n.t('flash.success')
        redirect_to admin_appointments_path
      else
        flash[:danger] = I18n.t('flash.danger')
      end
    end

    private

    def combine_date_time(date, time)
      return unless date && time

      DateTime.parse(" #{date} #{time}:00")
    end

    def appointment_params
      params.require(:appointment).permit(:doctor_id, :patient_id, :date, :time_hour, :time, :description, :status, :title)
    end

    def load_doctors
      @doctors = Doctor.all
    end
  end
end
