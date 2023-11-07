require "rails_helper"

RSpec.describe "/developer_apps", type: :request do
  describe "PUT /developer_apps/:id/archive" do
    before :each do
      @developer_app = create(:developer_app)
    end

    context "as non-logged in user" do
      it "redirects to login page" do
        put archive_developer_app_url(@developer_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "as a logged in user" do
      before :each do
        @user = create(:user)
        sign_in(@user)
      end

      context "not a team member" do
        it "cannot archive app " do
          put archive_developer_app_url(@developer_app)
          expect(response).to have_http_status(:see_other)
          expect(@developer_app.archived_at).to eq nil
        end
      end

      context "with read-only membership" do
        it "cannot archive app" do
          @developer_app.app_memberships.create(user_id: @user.id)
          put archive_developer_app_url(@developer_app)
          expect(response).to have_http_status(:see_other)
          expect(@developer_app.archived_at).to eq nil
        end
      end
    end
  end

  describe "PUT /developer_apps/:id/unarchive" do
    before :each do
      @developer_app = create(:developer_app, archived_at: Time.now)
    end

    context "as non-logged in user" do
      it "redirects to login page" do
        put unarchive_developer_app_url(@developer_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "as a logged in user" do
      before :each do
        @user = create(:user)
        sign_in(@user)
      end

      context "not a team member" do
        it "cannot unarchive app " do
          put unarchive_developer_app_url(@developer_app)
          expect(response).to have_http_status(:see_other)
          expect(@developer_app.archived_at).not_to eq nil
        end
      end

      context "with read-only membership" do
        it "cannot unarchive app" do
          @developer_app.app_memberships.create(user_id: @user.id)
          put unarchive_developer_app_url(@developer_app)
          expect(response).to have_http_status(:see_other)
          expect(@developer_app.archived_at).not_to eq nil
        end
      end
    end
  end
end
