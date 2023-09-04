class DeveloperAppsController < ApplicationController

    def index
        @developer_apps = DeveloperApp.all
    end

    def show
        @developer_app = DeveloperApp.find(params[:id])
    end

    def new
        @developer_app = DeveloperApp.new
    end

    def create
        @developer_app = DeveloperApp.new(developer_app_params)

        if @developer_app.save
            redirect_to @developer_app
            flash[:success] = "Developer app successfully created"
        else
            render :new, status: :unprocessable_entity
        end
    end

    private
        
        def developer_app_params
            params.require(:developer_app).permit(:name)
        end
end
