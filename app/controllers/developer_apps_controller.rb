class DeveloperAppsController < ApplicationController
    before_action :set_developer_app, only: [:show, :edit, :update]
    before_action :authenticate_user!
    before_action :authorized_for_app?, only: [:show, :edit, :update]

    def index
        @developer_apps = current_user.developer_apps
    end

    def show
        @app_memberships = @developer_app.app_memberships
    end

    def new
        @developer_app = DeveloperApp.new
    end

    def create
        @developer_app = DeveloperApp.new(developer_app_params)

        if @developer_app.save
            flash[:success] = "Developer app successfully created"
            redirect_to @developer_app
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @developer_app.update(developer_app_params)
            redirect_to @developer_app
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private
        
        def developer_app_params
            params.require(:developer_app).permit(:name)
        end

        def set_developer_app
            @developer_app = DeveloperApp.find(params[:id])
        end

        def authorized_for_app?
            unless @developer_app.members.include?(current_user) || current_user.platform_admin?
                flash[:warning] = "Unauthorized request"
                redirect_to(developer_apps_path, status: :see_other)
            end
        end
end
