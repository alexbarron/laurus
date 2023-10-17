class AppInvitationsController < ApplicationController
  before_action :set_app_invitation, only: %i[ show edit update destroy ]
  before_action :set_developer_app, only: %i[ new create ]
  before_action :authorized_to_invite?, only: %i[ new create ]

  # GET /app_invitations or /app_invitations.json
  def index
    @app_invitations = AppInvitation.all
  end

  # GET /app_invitations/1 or /app_invitations/1.json
  def show
  end

  # GET /app_invitations/new
  def new
    @app_invitation = current_user.sent_invitations.build(developer_app_id: @developer_app.id)
  end

  # POST /app_invitations or /app_invitations.json
  def create
    #@app_invitation = AppInvitation.new(app_invitation_params)
    @app_invitation = current_user.sent_invitations.build(app_invitation_params)
    @app_invitation.developer_app = @developer_app

    if invitee = User.find_by(email: params[:app_invitation][:invitee_email])
      @app_invitation.invitee_id = invitee.id
    end

    respond_to do |format|
      if @app_invitation.save
        format.html { redirect_to app_invitation_url(@app_invitation), notice: "App invitation was successfully created." }
        format.json { render :show, status: :created, location: @app_invitation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_invitations/1 or /app_invitations/1.json
  def destroy
    @app_invitation.destroy

    respond_to do |format|
      format.html { redirect_to app_invitations_url, notice: "App invitation was successfully destroyed." }
      format.json { head :no_content }
    end
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
      unless (!!@current_user_membership && !!@current_user_membership.admin?)
          flash[:warning] = "Unauthorized request"
          redirect_to @developer_app
      end
  end
end