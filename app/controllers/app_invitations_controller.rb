class AppInvitationsController < ApplicationController
  before_action :set_app_invitation, only: %i[ show edit update destroy ]

  # GET /app_invitations or /app_invitations.json
  def index
    @app_invitations = AppInvitation.all
  end

  # GET /app_invitations/1 or /app_invitations/1.json
  def show
  end

  # GET /app_invitations/new
  def new
    @app_invitation = AppInvitation.new
  end

  # GET /app_invitations/1/edit
  def edit
  end

  # POST /app_invitations or /app_invitations.json
  def create
    @app_invitation = AppInvitation.new(app_invitation_params)

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

  # PATCH/PUT /app_invitations/1 or /app_invitations/1.json
  def update
    respond_to do |format|
      if @app_invitation.update(app_invitation_params)
        format.html { redirect_to app_invitation_url(@app_invitation), notice: "App invitation was successfully updated." }
        format.json { render :show, status: :ok, location: @app_invitation }
      else
        format.html { render :edit, status: :unprocessable_entity }
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

    # Only allow a list of trusted parameters through.
    def app_invitation_params
      params.require(:app_invitation).permit(:inviter_id, :invitee_id, :invitee_email, :developer_app_id, :admin, :status)
    end
end
