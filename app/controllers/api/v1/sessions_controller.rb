# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Logged in successfully.', user: resource }, status: :ok
    else
      render json: { message: 'Invalid login credentials.' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    head :no_content
  end
end
