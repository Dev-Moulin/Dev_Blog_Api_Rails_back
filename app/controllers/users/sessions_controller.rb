# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # GET /resource/sign_in
  # def new
  #   super
  # end

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    token = current_token
    render json: {
      status: { code: 200, message: 'Connecté avec succès.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      token: token
    }
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "Déconnecté avec succès."
      }
    else
      render json: {
        status: 401,
        message: "Hmm, quelque chose s'est mal passé."
      }
    end
  end
end
