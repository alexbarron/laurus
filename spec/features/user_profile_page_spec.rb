require 'rails_helper'

feature 'User profile page' do
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

    scenario "can view user's own profile page" do
      visit user_path(@user)

      expect(page).to have_content @user.name
      expect(page).to have_content @user.email
    end

    scenario "cannot view another user's profile page" do
      @second_user = create(:user, name: 'Second User', email: 'seconduser@example.com')
      visit user_path(@second_user)

      expect(page).to have_content 'Unauthorized request'
    end
  end

  context 'as a logged in platform admin user' do
    before :each do
      @admin_user = create(:user, platform_admin: true)
      @non_admin_user = create(:user, name: 'Normal User', email: 'normaluser@example.com')
      sign_in(@admin_user)
    end

    scenario "can view any user's profile page" do
      visit user_path(@non_admin_user)

      expect(page).to have_content @non_admin_user.name
      expect(page).to have_content @non_admin_user.email
      expect(page).not_to have_content @admin_user.email
    end
  end
end
