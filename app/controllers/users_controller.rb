class UsersController < ApplicationController
  before_action :authorized_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @app_memberships = @user.app_memberships
  end

  private

    def authorized_user
      @user = User.find(params[:id])
      unless current_user == @user || current_user.platform_admin?
          flash[:warning] = "Unauthorized request"
          redirect_to(developer_apps_path, status: :see_other)
      end
    end

end
