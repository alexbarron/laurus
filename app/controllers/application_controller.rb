class ApplicationController < ActionController::Base

    private

        def platform_admin?
            unless current_user.platform_admin?
                flash[:warning] = "Unauthorized request"
                redirect_to(root_path, status: :see_other)
            end
        end
end
