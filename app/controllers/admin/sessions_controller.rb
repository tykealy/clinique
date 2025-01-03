# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in

  # POST /resource/sign_in
  def create
    super
    return unless user_signed_in?

    flash[:notice] = "Welcome back, #{current_user.email}!"
  end

  def destory
    super
    flash[:notice] = I18n.t('flash.notice.logout')

    redirect_to new_user_session_path
  end

  # DELETE /resource/sign_out

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
