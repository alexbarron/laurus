class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :name)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :current_password, :name)
  end
end
