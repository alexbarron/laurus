require 'rails_helper'

feature 'Managing API grants' do
  before :each do
    @developer_app = create(:developer_app)
  end

  context 'as a non logged in user' do
    scenario 'gets redirected to sign in page' do
      visit manage_developer_app_grants_path(@developer_app)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'as a logged in non platform admin user' do
    before :each do
      @user = create(:user)
      @app_membership = @developer_app.app_memberships.create(user_id: @user.id)
      sign_in(@user)
    end

    scenario 'cannot see manage grants link' do
      visit developer_app_path(@developer_app)

      expect(page).not_to have_content 'Manage Grants'
    end

    scenario 'gets redirected to root path' do
      visit manage_developer_app_grants_path(@developer_app)

      expect(page).to have_content 'Unauthorized request'
    end
  end

  context 'as a logged in platform admin user' do
    before :each do
      @platform_admin_user = create(:user, platform_admin: true)
      @endpoint = create(:endpoint)
      sign_in(@platform_admin_user)
    end

    scenario 'can manage grants for their own app' do
      @app_membership = @developer_app.app_memberships.create(user_id: @platform_admin_user.id)

      visit developer_app_path(@developer_app)

      click_on 'Manage Grants'
      check
      click_on 'Set Grants'

      expect(page).to have_content 'Developer app successfully updated'
      expect(page).to have_content "#{@endpoint.method} #{@endpoint.path}"

      click_on 'Manage Grants'
      uncheck
      click_on 'Set Grants'

      expect(page).to have_content 'Developer app successfully updated'
      expect(page).not_to have_content "#{@endpoint.method} #{@endpoint.path}"
    end

    scenario "can manage grants for another user's app" do
      @second_user = create(:user, name: 'Second User', email: 'seconduser@example.com')
      @app_membership = @developer_app.app_memberships.create(user_id: @second_user.id)

      visit developer_app_path(@developer_app)

      click_on 'Manage Grants'
      check
      click_on 'Set Grants'

      expect(page).to have_content 'Developer app successfully updated'
      expect(page).to have_content "#{@endpoint.method} #{@endpoint.path}"

      click_on 'Manage Grants'
      uncheck
      click_on 'Set Grants'

      expect(page).to have_content 'Developer app successfully updated'
      expect(page).not_to have_content "#{@endpoint.method} #{@endpoint.path}"
    end
  end
end
