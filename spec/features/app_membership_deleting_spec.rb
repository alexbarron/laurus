require "rails_helper"

feature "App membership deleting" do
  before :each do
    @developer_app = create(:developer_app)
    @admin_user = create(:user)
    @teammate = create(:user, email: "nonadmin@example.com", name: "Mr Non Admin")
    @admin_app_membership = @developer_app.app_memberships.create(user_id: @admin_user.id, admin: true)
    @nonadmin_app_membership = @developer_app.app_memberships.create(user_id: @teammate.id, admin: false)
  end

  context "as a logged in non admin team member" do
    before :each do
      sign_in(@teammate)
    end

    scenario "cannot see Edit Role button" do
      visit developer_app_path(@developer_app)

      expect(page).not_to have_content "Remove"
    end
  end

  context "as a logged in admin team member" do
    before :each do
      sign_in(@admin_user)
    end

    scenario "can delete a team member" do
      visit developer_app_path(@developer_app)
      click_link "Team Members"

      expect(page).to have_css("td", exact_text: @teammate.name, visible: true, count: 1)
      expect(page).to have_css("td", exact_text: "Read-only", visible: true, count: 1)

      click_link "Remove"

      expect(page).to have_content("#{@teammate.name} was removed from the app.")
      expect(page).to have_css("td", exact_text: @teammate.name, visible: true, count: 0)
      expect(page).to have_css("td", exact_text: "Read-only", visible: true, count: 0)

      # Ensure remove button does not appear for admin's own membership
      expect(page).to have_css("a", exact_text: "Remove", visible: true, count: 0)
    end
  end
end
