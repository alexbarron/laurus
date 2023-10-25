class AppMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_membership
  before_action :set_current_user_membership
  before_action :authorized_to_edit_role?

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

    def set_current_user_membership
      @current_user_membership = AppMembership.where(user_id: current_user.id, developer_app_id: @app_membership.developer_app_id).first
    end

    def authorized_to_edit_role?
        unless current_user.platform_admin? || (!!@current_user_membership && !!@current_user_membership.admin?)
            flash[:warning] = "Unauthorized request"
            redirect_to @app_membership.developer_app
        end
    end
end
