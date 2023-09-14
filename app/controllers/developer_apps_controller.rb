class DeveloperAppsController < ApplicationController
    before_action :set_developer_app, only: [:show, :edit, :update, :manage_grants, :archive, :unarchive]
    before_action :authenticate_user!
    before_action :authorized_for_app?, only: [:show, :edit, :update, :archive, :unarchive]

    def index
        @developer_apps = current_user.developer_apps.paginate(page: params[:page])
    end

    def show
        @app_memberships = @developer_app.app_memberships
        @endpoints = @developer_app.endpoints.ordered_by_path
    end

    def new
        @developer_app = DeveloperApp.new
    end

    def create
        @developer_app = current_user.developer_apps.new(developer_app_params)

        if @developer_app.save
            @developer_app.app_memberships.create(user_id: current_user.id)
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
            flash[:success] = "Developer app successfully updated"
            redirect_to @developer_app
        else
            render :manage_grants, status: :unprocessable_entity
        end
    end

    def manage_grants
        @endpoints = Endpoint.all
    end

    def archive
        @developer_app.archive
        flash[:success] = "Developer app archived"
        redirect_to @developer_app
    end

    def unarchive
        @developer_app.unarchive
        flash[:success] = "Developer app reactivated"
        redirect_to @developer_app
    end

    private
        
        def developer_app_params
            params.require(:developer_app).permit(:name, endpoint_ids: [])
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
