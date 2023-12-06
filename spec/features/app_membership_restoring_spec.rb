require "rails_helper"

feature "App membership restoring" do
  before :each do
    @developer_app = create(:developer_app)
    @admin_user = create(:user)
    @admin_app_membership = @developer_app.app_memberships.create(user_id: @admin_user.id, admin: true)
    @removed_user = create(:user, email: "removed@example.com", name: "Removed User")
    @removed_app_membership = @developer_app.app_memberships.create(user_id: @removed_user.id, admin: false,
                                                                    deleted_at: Time.now)
  end

  context "as a logged in non admin team member" do
    before :each do
      @nonadmin = create(:user, email: "nonadmin@example.com", name: "Non Admin User")
      @nonadmin_app_membership = @developer_app.app_memberships.create(user_id: @nonadmin.id, admin: false)
      sign_in(@nonadmin)
    end

    scenario "can see removed members but not restore them" do
      visit developer_app_path(@developer_app)
      click_link "Team Members"
      click_link "See Removed Members"

      expect(page).to have_css("th", exact_text: @removed_user.name, visible: true, count: 1)
      expect(page).to have_css("td", exact_text: "Read-only", visible: true, count: 1)
      expect(page).not_to have_css("a", exact_text: "Restore", visible: true, count: 1)
    end
  end

  context "as a logged in admin team member" do
    before :each do
      sign_in(@admin_user)
    end

    scenario "can restore a team member" do
      visit developer_app_path(@developer_app)
      click_link "Team Members"

      expect(page).to have_css("th", exact_text: @removed_user.name, visible: true, count: 0)
      expect(page).to have_css("td", exact_text: "Read-only", visible: true, count: 0)

      click_link "See Removed Members"

      expect(page).to have_css("th", exact_text: @removed_user.name, visible: true, count: 1)
      expect(page).to have_css("td", exact_text: "Read-only", visible: true, count: 1)

      click_link "Restore"

      expect(page).to have_content("#{@removed_user.name} successfully restored")
      expect(page).to have_css("th", exact_text: @removed_user.name, visible: true, count: 1)
      expect(page).to have_css("td", exact_text: "Read-only", visible: true, count: 1)
    end
  end
end
