class AppMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_membership, except: [:index]
  before_action :set_developer_app
  before_action :cannot_modify_own_membership, except: [:index]
  before_action -> { set_current_user_membership(@developer_app) }
  before_action -> { authorized_to_edit_app?(@developer_app) }, except: [:index]

  def index
    @app_memberships = @developer_app.app_memberships.kept
    @sent_invitations = @developer_app.app_invitations.where(status: 'pending').order('created_at DESC')
  end

  def edit; end

  def update
    if @app_membership.update(app_membership_params)
      redirect_to developer_app_app_memberships_path(developer_app_id: @app_membership.developer_app.id)
    else
      render :manage_grants, status: :unprocessable_entity
    end
  end

  def destroy
    @app_membership.discard

    respond_to do |format|
      format.html do
        redirect_to developer_app_app_memberships_path(developer_app_id: @app_membership.developer_app.id),
                    notice: "#{@app_membership.user.name} was removed from the app."
      end
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
    return unless @app_membership.user == current_user && !current_user.platform_admin?

    flash[:warning] = 'You cannot modify your own app membership.'
    redirect_to @app_membership.developer_app
  end
end
