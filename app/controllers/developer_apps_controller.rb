class DeveloperAppsController < ApplicationController

    def index
        @developer_apps = DeveloperApp.all
    end

    def show
        @developer_app = DeveloperApp.find(params[:id])
    end
end
