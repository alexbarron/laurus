require 'rails_helper'

feature 'User login and logout' do
  context 'as a user with a correct email and password' do
    before :each do
      @user = create(:user)
    end

    scenario 'can log in and out successfully' do
      visit root_path
      click_link 'Log In'
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: 'password'
      click_on 'Log in'

      expect(page).to have_content 'My Apps'
      expect(page).to have_content @user.name
      expect(page).to have_content 'Log Out'

      click_on 'Log Out'
      expect(page).to have_content 'Signed out successfully'
      expect(page).to have_content 'Log In'
    end
  end

  context 'as a user with an invalid email and/or password' do
    before :each do
      @user = create(:user)
    end

    scenario 'cannot log in successfully' do
      visit root_path
      click_link 'Log In'
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: 'wrongpassword'
      click_on 'Log in'

      expect(page).to have_content 'Log in'
      expect(page).to have_content 'Invalid Email or password'
    end
  end
end
