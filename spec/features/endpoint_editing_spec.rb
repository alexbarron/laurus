require "rails_helper"

feature "Endpoint creation" do
  before :each do
    @endpoint = create(:endpoint)
  end

  context "as a non logged in user" do
    scenario "gets redirected to sign in page" do
      visit endpoint_path(@endpoint)
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end

  context "as a logged in non platform admin user" do
    before :each do
      @user = create(:user)
      sign_in(@user)
    end

    scenario "gets redirected to root path" do
      visit endpoint_path(@endpoint)
      expect(page).to have_content "Unauthorized request"
    end
  end

  context "as a logged in platform admin user" do
    before :each do
      @user = create(:user, platform_admin: true)
      sign_in(@user)
    end

    scenario "can edit endpoint" do
      edited_path = "/v2/edited_widgets"
      edited_method = "PUT"
      edited_description = "A new and improved endpoint"

      visit endpoint_path(@endpoint)

      click_link "Edit Endpoint"
      fill_in "endpoint_path", with: edited_path
      select edited_method, from: "endpoint_method"
      fill_in "endpoint_description", with: edited_description
      click_on "Submit"

      expect(page).to have_content "Endpoint successfully updated"
      expect(page).to have_content "#{edited_method} #{edited_path}"
      expect(page).to have_content edited_description
    end
  end
end
