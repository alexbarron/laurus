require 'rails_helper'

feature 'Endpoint creation' do
  context 'as a non logged in user' do
    scenario 'gets redirected to sign in page' do
      visit new_endpoint_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'as a logged in non platform admin user' do
    before :each do
      @user = create(:user)
      sign_in(@user)
    end

    scenario 'gets redirected to root path' do
      visit new_endpoint_path
      expect(page).to have_content 'Unauthorized request'
    end
  end

  context 'as a logged in platform admin user' do
    before :each do
      @user = create(:user, platform_admin: true)
      sign_in(@user)
    end

    scenario 'can create a new endpoint' do
      path = '/v2/widgets'
      method = 'POST'
      description = 'A brilliant endpoint!'

      visit endpoints_path
      click_link 'New Endpoint'
      fill_in 'endpoint_path', with: path
      select method, from: 'endpoint_method'
      fill_in 'endpoint_description', with: description
      click_on 'Submit'

      expect(page).to have_content 'Endpoint successfully created'
      expect(page).to have_content "#{method} #{path}"
      expect(page).to have_content description
    end
  end
end
