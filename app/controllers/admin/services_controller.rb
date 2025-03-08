module Admin
  class ServicesController < BaseController
    before_action :set_service, only: %i[edit update destroy toggle_status]
    def index
      @services = if params[:query].present?
                    @current_clinic.services.where('name ILIKE ?', "%#{params[:query]}%").order(status: :desc).page(params[:page]).per(10)
                  else
                    @current_clinic.services.order(status: :desc).page(params[:page]).per(10)
                  end
    end

    def new
      @service = Service.new
    end

    def edit; end

    def create
      @service = @current_clinic.services.new(service_params)
      if @service.save
        flash[:sucess] = I18n.t('flash.created', record: @service.class.name)
        redirect_to admin_services_path
      else
        flash[:danger] = I18n.t('flash.danger', record: @service.class.name)
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @service.update(service_params)
        flash[:success] = I18n.t('flash.created', record: @service.class.name)
        redirect_to admin_services_path
      else
        flash[:danger] = I18n.t('flash.danger', record: @service.class.name)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy; end

    def toggle_status
      new_status = @service.active? ? :inactive : :active
      if @service.update(status: new_status)
        flash[:success] = I18n.t('flash.updated', record: @service.class.name)
      else
        flash[:danger] = I18n.t('flash.danger', record: @service.class.name)
      end
      redirect_to admin_services_path
    end

    private

    def set_service
      @service = @current_clinic.services.find(params[:id])
    end

    def service_params
      params.require(:service).permit(:name, :description, :price, :price_type, :price_max, :status)
    end
  end
end
