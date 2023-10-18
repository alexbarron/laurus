require 'rails_helper'

feature 'App invitation creation' do
    context "as a non logged in user" do
        scenario "gets redirected to sign in page" do
            @developer_app = create(:developer_app)
            visit new_developer_app_app_invitation_path(@developer_app)
            expect(page).to have_content "You need to sign in or sign up before continuing."
        end
    end

    context "as a logged in non-admin user" do
        before :each do
            @inviting_user = create(:user)
            sign_in(@inviting_user)
            @developer_app = create(:developer_app)
            @app_membership = @developer_app.app_memberships.create(user_id: @inviting_user.id, admin: false)
        end

        scenario "cannot create a new app invitation" do
            visit developer_app_path(@developer_app)
            expect(page).not_to have_content "Add Members"

            visit new_developer_app_app_invitation_path(@developer_app)
            expect(page).to have_content "Unauthorized request"
        end
    end

    context "as a logged in admin user" do
        before :each do
            @invited_user = create(:user, email: "invited_user@example.com")
            @inviting_user = create(:user)
            sign_in(@inviting_user)
            @developer_app = create(:developer_app)
            @app_membership = @developer_app.app_memberships.create(user_id: @inviting_user.id, admin: true)
        end

        scenario "can create a new app invitation" do
            visit developer_app_path(@developer_app)
            click_on "Add Members"

            fill_in "app_invitation_invitee_email", with: @invited_user.email
            click_on "Submit"

            expect(page).to have_content "App invitation was successfully created"
            expect(page).to have_content @invited_user.name
            expect(page).to have_content @invited_user.email
            expect(page).to have_content @inviting_user.name
            expect(page).to have_content "pending"
        end

        scenario "cannot create a duplicate app invitation" do
            @app_invitation = @developer_app.app_invitations.create(
                invitee_email: @invited_user.email,
                invitee_id: @invited_user.id,
                inviter_id: @inviting_user.id,
                admin: false
            )

            visit developer_app_path(@developer_app)
            click_on "Add Members"

            fill_in "app_invitation_invitee_email", with: @invited_user.email
            click_on "Submit"

            expect(page).to have_content "Invitee email has already been invited to this developer app"
        end
    end
end