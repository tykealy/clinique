module Admin
  class AppointmentsController < BaseController
    def index
      @appointments = Appointment.all
    end
  end
end
