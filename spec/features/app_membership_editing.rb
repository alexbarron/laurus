require 'rails_helper'

feature 'App membership editing' do
    before :each do
        @developer_app = create(:developer_app)
        @admin_user = create(:user)
        @teammate = create(:user, email: "nonadmin@example.com", name: "Mr Non Admin")
        @admin_app_membership = @developer_app.app_memberships.create(user_id: @admin_user.id, admin: true)
        @nonadmin_app_membership = @developer_app.app_memberships.create(user_id: @teammate.id, admin: false)
    end

    context "as a non logged in user" do
        scenario "gets redirected to sign in page" do
            visit edit_app_membership_path(@nonadmin_app_membership)
            expect(page).to have_current_path(new_user_session_path)
            expect(page).to have_content "You need to sign in or sign up before continuing."
        end
    end

    context "as a logged in non team member" do
        before :each do
            @non_teammate = create(:user, email: "nonteammate@example.com", name: "Mr Non Teammate")
            sign_in(@non_teammate)
        end

        scenario "cannot edit developer app they don't belong to" do
            visit edit_app_membership_path(@nonadmin_app_membership)
            expect(page).to have_current_path(developer_apps_path)
            expect(page).to have_content "Unauthorized request"
        end
    end

    context "as a logged in non admin team member" do
        before :each do
            sign_in(@teammate)
        end

        scenario "cannot see Edit Role button" do
            visit developer_app_path(@developer_app)
            expect(page).not_to have_content "Edit Role"
        end

        scenario "cannot edit another team member's role thru direct navigation" do
            visit edit_app_membership_path(@admin_app_membership)
            expect(page).to have_current_path(developer_app_path(@developer_app))
            expect(page).to have_content "Unauthorized request"
        end
    end

    context "as a logged in admin team member" do
        before :each do
            sign_in(@admin_user)
        end

        scenario "can edit another team member's role" do
            visit developer_app_path(@developer_app)
            expect(page).to have_css('td', :exact_text => 'Admin', :visible => true, :count => 1)

            click_link 'Edit Role'
            check
            click_on "Submit"

            expect(page).to have_current_path(developer_app_path(@developer_app))
            expect(page).to have_css('td', :exact_text => 'Admin', :visible => true, :count => 2)

            click_link 'Edit Role'
            uncheck
            click_on "Submit"

            expect(page).to have_css('td', :exact_text => 'Admin', :visible => true, :count => 1)
        end
    end


end