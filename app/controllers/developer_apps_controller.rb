class DeveloperAppsController < ApplicationController
    before_action :set_developer_app, only: [:show, :edit, :update]

    def index
        @developer_apps = DeveloperApp.all
    end

    def show
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
end
