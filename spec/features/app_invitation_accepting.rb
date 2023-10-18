require 'rails_helper'

feature 'App invitation acceptings' do
    context "as a non logged in user" do
        scenario "gets redirected to sign in page" do
            skip
        end
    end

    context "as a logged in uninvited user" do
        scenario "cannot create a new app invitation" do
            skip
        end
    end

    context "as a logged in invited user" do
        before :each do
            @invited_user = create(:user, email: "invited_user@example.com")
            @inviting_user = create(:user)
            sign_in(@invited_user)
            @developer_app = create(:developer_app)
            @app_membership = @developer_app.app_memberships.create(user_id: @inviting_user.id, admin: true)
            @app_invitation = @developer_app.app_invitations.create(
                invitee_email: @invited_user.email,
                invitee_id: @invited_user.id,
                inviter_id: @inviting_user.id,
                admin: false
            )
        end

        scenario "can accept app invitation" do
            visit developer_app_app_invitations_path
            click_on "Accept"

            fill_in "app_invitation_invitee_email", with: @invited_user.email
            click_on "Submit"

            expect(page).to have_content "App invitation accepted"
            expect(page).to have_content @invited_user.name
            expect(page).to have_content "Read-only"
        end
    end
end