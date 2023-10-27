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

        def set_current_user_membership(developer_app)
            @current_user_membership = developer_app.app_memberships.where(user_id: current_user.id).first
        end

        def authorized_to_view_app?(developer_app)
            unless current_user.platform_admin? || !!@current_user_membership
                flash[:warning] = "Unauthorized request"
                redirect_to(developer_apps_path, status: :see_other)
            end
        end

        def authorized_to_edit_app?(developer_app)
            unless current_user.platform_admin? || (!!@current_user_membership && !!@current_user_membership.admin?)
                flash[:warning] = "Unauthorized request"
                redirect_to developer_app
            end
        end
end
