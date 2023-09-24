require 'rails_helper'

feature 'Developer app archiving' do
    before :each do
        @developer_app = create(:developer_app)
    end

    context "as a logged in authorized user" do
        before :each do
            @user = create(:user)
            sign_in(@user)
            @app_membership = @developer_app.app_memberships.create(user_id: @user.id)
        end

        scenario "can archive their developer app" do
            with_versioning do 
                visit developer_app_path(@developer_app)
                
                    click_on 'Archive'
                    

                expect(page).to have_content "Developer app archived"
                expect(page).to have_content "Status: Archived"
            end
        end
    end

    context "as a logged in unauthorized user" do
        before :each do
            @user = create(:user)
            sign_in(@user)
        end

        scenario "cannot edit developer app they don't belong to" do
            visit edit_developer_app_path(@developer_app)
            expect(page).to have_content "Unauthorized request"
            expect(page).to have_content "My Apps"
        end
    end
end
