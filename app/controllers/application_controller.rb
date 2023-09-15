class ApplicationController < ActionController::Base
    before_action :set_paper_trail_whodunnit

    private

        def authorized_user?
            @user = User.find(params[:id])
            unless current_user == @user || current_user.platform_admin?
                flash[:warning] = "Unauthorized request"
                redirect_to(developer_apps_path, status: :see_other)
            end
        end

        def platform_admin?
            unless current_user.platform_admin?
                flash[:warning] = "Unauthorized request"
                redirect_to(root_path, status: :see_other)
            end
        end
end
