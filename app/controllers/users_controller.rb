class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized_user?, only: [:show]

  def show
    @user = User.find(params[:id])
    @app_memberships = @user.app_memberships.paginate(page: params[:page])
  end
end
