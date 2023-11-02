class DeveloperAppsController < ApplicationController
    before_action :set_developer_app, only: [:show, :edit, :update, :manage_grants, :archive, :unarchive]
    before_action :authenticate_user!
    before_action -> { set_current_user_membership(@developer_app) }, only: [:show, :edit, :update, :archive, :unarchive]
    before_action -> { authorized_to_view_app?(@developer_app) }, only: [:show]
    before_action -> { authorized_to_edit_app?(@developer_app) }, only: [:edit, :update, :archive, :unarchive]
    before_action :platform_admin?, only: [:manage_grants]

    def index
        @developer_apps = current_user.developer_apps.order("created_at DESC").paginate(page: params[:page])
    end

    def show
        @app_memberships = @developer_app.app_memberships
        @endpoints = @developer_app.endpoints.ordered_by_path
        @activities = build_activity_log
        @sent_invitations = @developer_app.app_invitations.where(status: "pending").order("created_at DESC")
    end

    def new
        @developer_app = DeveloperApp.new
    end

    def create
        @developer_app = current_user.developer_apps.new(developer_app_params)

        if @developer_app.save
            @developer_app.app_memberships.create(user_id: current_user.id, admin: true)
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
        elsif request.referer == manage_developer_app_grants_url
            render :manage_grants, status: :unprocessable_entity
        else 
            render :edit, status: :unprocessable_entity
        end
    end

    def manage_grants
        @endpoints = Endpoint.all
    end

    def archive
        @developer_app.archive
        flash[:success] = "Developer app archived"
        redirect_to @developer_app, status: :see_other
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

        def build_activity_log
            versions = @developer_app.versions.to_a
            @app_memberships.each do |app_membership|
                versions << app_membership.versions
            end
            return versions.to_a.flatten!.sort_by { |v| v[:created_at] }.reverse
        end
end
