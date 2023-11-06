require 'rails_helper'

feature 'Developer app creation' do
  context 'as a non logged in user' do
    scenario 'gets redirected to sign in page' do
      visit new_developer_app_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'as a logged in user' do
    before :each do
      @user = create(:user)
      sign_in(@user)
    end

    scenario 'can create a new developer app' do
      app_name = 'Awesome App'

      visit developer_apps_path
      click_link 'New App', match: :first
      fill_in 'developer_app_name', with: app_name
      click_on 'Submit'

      expect(page).to have_content 'Developer app successfully created'
      expect(page).to have_content app_name

      click_link 'My Apps'
      expect(page).to have_content app_name
    end

    scenario 'cannot create a new developer if missing app name' do
      visit new_developer_app_path
      click_on 'Submit'
      expect(page).to have_content "Name can't be blank"
    end
  end
end
