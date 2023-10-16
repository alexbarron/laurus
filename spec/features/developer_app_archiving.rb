require 'rails_helper'

feature 'Developer app archiving' do
    before :each do
        @developer_app = create(:developer_app)
    end

    context "as a logged in admin team member" do
        before :each do
            @user = create(:user)
            sign_in(@user)
            @app_membership = @developer_app.app_memberships.create(user_id: @user.id, admin: true)
        end

        scenario "can archive and unarchive their developer app" do
            with_versioning do 
                visit developer_app_path(@developer_app)
                click_on 'Archive'

                expect(page).to have_content "Developer app archived"
                expect(page).to have_content "Status: Archived"

                click_on 'Unarchive'

                expect(page).to have_content "Developer app reactivated"
                expect(page).to have_content "Status: Active"
            end
        end
    end

    context "as a logged in read-only team member" do
        before :each do
            @user = create(:user)
            sign_in(@user)
            @app_membership = @developer_app.app_memberships.create(user_id: @user.id)
        end

        scenario "cannot archive and unarchive their developer app" do
            visit edit_developer_app_path(@developer_app)
            expect(page).to have_content "Unauthorized request"
        end
    end

    context "as a logged in unauthorized user" do
        before :each do
            @user = create(:user)
            sign_in(@user)
        end

        scenario "cannot archive developer app they don't belong to" do
            visit edit_developer_app_path(@developer_app)
            expect(page).to have_content "Unauthorized request"
            expect(page).to have_content "My Apps"
        end
    end
end
