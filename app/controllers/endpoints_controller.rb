class EndpointsController < ApplicationController
  before_action :platform_admin?

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

    def endpoint_params
      params.require(:endpoint).permit(:path, :method, :description)
    end
end
