require 'rails_helper'

feature 'Developer app archiving' do
    before :each do
        @developer_app = create(:developer_app)
        @user = create(:user)
    end

    context "as a non-logged in user" do
        scenario "gets redirected to sign in page" do
            skip # How to test this in a feature spec when archive method is a PUT method
            visit archive_developer_app_path(@developer_app)

            expect(page).to have_current_path(new_user_session_path)
            expect(page).to have_content "You need to sign in or sign up before continuing."
        end
    end

    context "as a logged in user" do
        before :each do
            sign_in(@user)
        end

        context "not a team member" do 
            scenario "cannot archive/unarchive developer app" do
                skip
                visit archive_developer_app_path(@developer_app)

                expect(page).to have_current_path(developer_app_path(@developer_app))
                expect(page).to have_content "Unauthorized request"

                visit unarchive_developer_app_path(@developer_app)
                expect(page).to have_current_path(developer_app_path(@developer_app))

                expect(page).to have_content "Unauthorized request"
            end
        end

        context "with read-only membership" do
            scenario "cannot see Archive button" do
                @app_membership = @developer_app.app_memberships.create(user_id: @user.id)
                visit developer_app_path(@developer_app)
    
                expect(page).not_to have_content "Archive"
            end
        end

        context "with admin membership" do
            scenario "can archive and unarchive their developer app" do
                @app_membership = @developer_app.app_memberships.create(user_id: @user.id, admin: true)

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
    end
end
