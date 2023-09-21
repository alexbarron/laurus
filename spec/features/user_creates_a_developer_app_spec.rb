require 'rails_helper'

feature 'User creates a developer app' do
    context "as a non logged in user" do
        scenario "cannot create a new developer app" do
            visit new_developer_app_path
            expect(page).to have_content "You need to sign in or sign up before continuing."
        end
    end
    
    context "as a logged in user" do
        before :each do
            @user = create(:user)
            sign_in(@user)
        end

        scenario "can create a new developer app" do
            app_name = "Awesome App"

            visit developer_apps_path
            click_link 'New App', match: :first
            fill_in "developer_app_name", with: app_name
            click_on "Submit"

            expect(page).to have_content "Developer app successfully created"
            expect(page).to have_content app_name
        end
    end
end