require 'rails_helper'

feature 'Developer app editing' do
    before :each do
        @developer_app = create(:developer_app)
    end

    context "as a non logged in user" do
        scenario "gets redirected to sign in page" do
            visit edit_developer_app_path(@developer_app)
            expect(page).to have_current_path(new_user_session_path)
        end
    end

    context "as a logged in unauthorized user" do
        before :each do
            @user = create(:user)
            sign_in(@user)
        end

        scenario "cannot edit developer app they don't belong to" do
            visit edit_developer_app_path(@developer_app)

            expect(page).to have_current_path(developer_apps_path)
            expect(page).to have_content "Unauthorized request"
        end
    end

    context "as a logged in non admin team member" do
        before :each do
            @user = create(:user)
            sign_in(@user)
            @app_membership = @developer_app.app_memberships.create(user_id: @user.id)
        end

        scenario "cannot edit their developer app" do
            visit edit_developer_app_path(@developer_app)
            expect(page).to have_content "Unauthorized request"
        end
    end

    context "as a logged in admin team member" do
        before :each do
            @user = create(:user)
            sign_in(@user)
            @app_membership = @developer_app.app_memberships.create(user_id: @user.id, admin: true)
        end

        scenario "can edit their developer app" do
            with_versioning do 
                original_name = @developer_app.name
                edited_name = "Humble App"

                visit developer_apps_path
                click_link 'Manage', match: :first
                click_link 'Settings'
                click_link 'Edit App'
                fill_in "developer_app_name", with: edited_name
                click_on "Submit"

                expect(page).to have_current_path(developer_app_path(@developer_app))
                expect(page).to have_content "Developer app successfully updated"
                click_link 'Activity'
                expect(page).to have_content "#{@user.name} changed name from #{original_name} to #{edited_name}"
            end
        end
    end
end