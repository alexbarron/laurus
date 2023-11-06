class AppInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_invitation, only: %i[show edit update destroy accept decline]
  before_action :set_developer_app, only: %i[new create accept decline]
  before_action :authorized_to_invite?, only: %i[new create]
  before_action :correct_user?, only: %i[accept decline]

  # GET /app_invitations or /app_invitations.json
  def index
    @sent_invitations = current_user.sent_invitations.order('created_at DESC')
    @received_invitations = current_user.received_invitations.order('created_at DESC')
  end

  # GET /app_invitations/1 or /app_invitations/1.json
  def show; end

  # GET /app_invitations/new
  def new
    @app_invitation = current_user.sent_invitations.build(developer_app_id: @developer_app.id)
  end

  # POST /app_invitations or /app_invitations.json
  def create
    # @app_invitation = AppInvitation.new(app_invitation_params)
    @app_invitation = current_user.sent_invitations.build(app_invitation_params)
    @app_invitation.developer_app = @developer_app

    if invitee = User.find_by(email: params[:app_invitation][:invitee_email])
      @app_invitation.invitee_id = invitee.id
    end

    respond_to do |format|
      if @app_invitation.save
        format.html { redirect_to developer_app_app_memberships_path(developer_app_id: @developer_app.id) }
        format.json { render :show, status: :created, location: @app_invitation }
        AppInvitationMailer.invited(@app_invitation).deliver_later
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_invitations/1 or /app_invitations/1.json
  def destroy
    @developer_app = @app_invitation.developer_app
    @app_invitation.destroy

    respond_to do |format|
      format.html do
        redirect_to developer_app_app_memberships_path(developer_app_id: @developer_app.id),
                    notice: 'App invitation was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  # GET /developer_apps/1/app_invitations/1/accept
  def accept
    @app_invitation.accept
    flash[:success] = 'App invitation accepted'
    redirect_to @developer_app
  rescue StandardError
    flash[:warning] = 'App invitation acceptance failed'
    redirect_to app_invitations_path
  end

  # GET /developer_apps/1/app_invitations/1/decline
  def decline
    @app_invitation.decline
    flash[:success] = 'App invitation declined'
    redirect_to app_invitations_path
  rescue StandardError
    flash[:warning] = 'App invitation declining failed'
    redirect_to app_invitations_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app_invitation
    @app_invitation = AppInvitation.find(params[:id])
  end

  def set_developer_app
    @developer_app = DeveloperApp.find(params[:developer_app_id])
  end

  # Only allow a list of trusted parameters through.
  def app_invitation_params
    params.require(:app_invitation).permit(:invitee_email, :admin)
  end

  def authorized_to_invite?
    @current_user_membership = @developer_app.app_memberships.where(user_id: current_user.id).first
    return if !!@current_user_membership && !!@current_user_membership.admin?

    flash[:warning] = 'Unauthorized request'
    redirect_to @developer_app
  end

  def correct_user?
    return if current_user == @app_invitation.invitee

    flash[:warning] = 'Unauthorized request'
    redirect_to app_invitations_path
  end
end
