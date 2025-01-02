module Admin
  class AppointmentsController < BaseController
    before_action :load_doctors
    def index
      start_date = params[:selected_date].present? ? params[:selected_date].to_date.beginning_of_week : Time.zone.today.beginning_of_week
      query = Admin::AppointmentQuery.new(start_date, @current_clinic.id)
      @selected_date = params[:selected_date].present? ? params[:selected_date].to_date : Time.zone.today
      @appointments = query.fetch_appointments_for_week
      @dates = query.weekdates
      @patients = []
      @appointment = Appointment.new
    end

    def show
      @appointment = Appointment.find(params[:id])
      render partial: 'appointment_card', locals: { appointment: @appointment }
    end

    def edit
      @appointment = Appointment.find(params[:id])
      @patients = Patient.where(id: @appointment.patient_id)
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
        redirect_to admin_appointments_path(selected_date: @appointment.date)
      else
        flash[:danger] = I18n.t('flash.danger')
      end
    end

    def update
      @appointment = Appointment.find(params[:id])
      date = appointment_params[:date]
      time = appointment_params[:time_hour]
      combined_date_time = combine_date_time(date, time)
      if @appointment.update(appointment_params.except(:time_hour))
        @appointment.update(date: combined_date_time)
        redirect_to admin_appointments_path(selected_date: @appointment.date)
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

    def filter_params
      params.permit(:doctor_id, :status, :selected_date)
    end

    def load_doctors
      @doctors = Doctor.all
    end
  end
end
