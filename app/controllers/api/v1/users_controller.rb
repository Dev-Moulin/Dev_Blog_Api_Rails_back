class Api::V1::UsersController < ApplicationController
  def register
    @user = User.new(user_params)
    if @user.save
      render json: {
        status: { code: 200, message: 'Utilisateur créé avec succès.' },
        data: @user
      }
    else
      render json: {
        status: { message: "Impossible de créer cet utilisateur." },
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
