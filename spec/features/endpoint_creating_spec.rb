require "rails_helper"

feature "Endpoint creation" do
  context "as a non logged in user" do
    scenario "gets redirected to sign in page" do
      visit new_endpoint_path
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end

  context "as a logged in non platform admin user" do
    before :each do
      @user = create(:user)
      sign_in(@user)
    end

    scenario "gets redirected to root path" do
      visit new_endpoint_path
      expect(page).to have_content "Unauthorized request"
    end
  end

  context "as a logged in platform admin user" do
    before :each do
      @user = create(:user, platform_admin: true)
      sign_in(@user)
    end

    scenario "can create a new endpoint" do
      path = "/v2/widgets"
      method = "POST"
      description = "A brilliant endpoint!"

      visit endpoints_path
      click_link "New Endpoint"
      fill_in "endpoint_path", with: path
      select method, from: "endpoint_method"
      fill_in "endpoint_description", with: description
      click_on "Submit"

      expect(page).to have_content "Endpoint successfully created"
      expect(page).to have_content "#{method} #{path}"
      expect(page).to have_content description
    end

    scenario "can import OpenAPI spec" do
      spec = "spec/fixtures/files/petstore.yaml"
      parsed_spec = OpenAPIParser.parse(YAML.load_file(spec))

      expected_count = 0
      parsed_spec.paths.raw_schema.each {|_k, v|
        expected_count += v.count
      }

      path_to_validate = parsed_spec.paths.raw_schema.first
      path_attributes = path_to_validate[1]["get"]["parameters"][0]

      visit new_endpoint_path
      attach_file "openapi_spec", spec
      click_button "Import"

      expect(page).to have_current_path(endpoints_path)
      expect(page).to have_content "/pet"
      expect(page).to have_content "Add a new pet to the store"
      expect(Endpoint.count).to be expected_count

      click_link path_to_validate[0]

      expect(page).to have_content path_attributes["name"]
      expect(page).to have_content path_attributes["in"]
      expect(page).to have_content path_attributes["description"]
      expect(page).to have_content path_attributes["schema"]["type"]
    end
  end
end
