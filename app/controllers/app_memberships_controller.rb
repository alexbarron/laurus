class AppMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_membership
  before_action :cannot_modify_own_membership
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
    @app_membership.discard

    respond_to do |format|
      format.html { redirect_to @app_membership.developer_app, notice: "#{@app_membership.user.name} was removed from the app." }
      format.json { head :no_content }
    end
  end

  private

    def set_app_membership
      @app_membership = AppMembership.find(params[:id])
    end
    
    def app_membership_params
      params.require(:app_membership).permit(:admin)
    end

    def cannot_modify_own_membership
      # Unless user is a platform admin
      if @app_membership.user == current_user && !current_user.platform_admin?
        flash[:warning] = "You cannot modify your own app membership."
        redirect_to @app_membership.developer_app
      end
    end
end
