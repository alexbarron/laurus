class AppMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_membership
  before_action -> { set_current_user_membership(@app_membership.developer_app) }
  before_action -> { authorized_to_edit_app?(@app_membership.developer_app) }, 

  def edit
  end

  def update
    if @app_membership.update(app_membership_params)
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
