class AppMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_membership

  def edit
  end

  def update
    if @app_membership.update(app_membership_params)
      flash[:success] = "App membership successfully updated"
      redirect_to @app_membership.developer_app
  else
      render :manage_grants, status: :unprocessable_entity
  end
  end

  def destroy
  end

  private

    def set_app_membership
      @app_membership = AppMembership.find(params[:id])
    end
    
    def app_membership_params
      params.require(:app_membership).permit(:admin)
    end
end
