require "rails_helper"

feature "App invitation declining" do
  before :each do
    @inviting_user = create(:user)
    @invited_user = create(:user, email: "invited_user@example.com")
    @developer_app = create(:developer_app)
    @app_membership = @developer_app.app_memberships.create(user_id: @inviting_user.id, admin: true)
    @app_invitation = @developer_app.app_invitations.create(
      invitee_email: @invited_user.email,
      invitee_id:    @invited_user.id,
      inviter_id:    @inviting_user.id,
      admin:         false
    )
  end

  context "as a non logged in user" do
    scenario "gets redirected to sign in page" do
      visit decline_app_invitation_path(developer_app_id: @developer_app.id, id: @app_invitation.id)

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end

  context "as a logged in non-invited user" do
    scenario "cannot decline app invitation" do
      @noninvited_user = create(:user, email: "non_invited_user@example.com")
      sign_in(@noninvited_user)

      visit decline_app_invitation_path(developer_app_id: @developer_app.id, id: @app_invitation.id)

      expect(page).to have_current_path(app_invitations_path)
      expect(page).to have_content "Unauthorized request"
    end
  end

  context "as a logged in invited user" do
    scenario "can decline app invitation" do
      sign_in(@invited_user)

      visit app_invitations_path
      click_on "Decline"

      expect(page).to have_current_path(app_invitations_path)
      expect(page).to have_content "App invitation declined"
    end
  end
end
