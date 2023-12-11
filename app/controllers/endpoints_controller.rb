class EndpointsController < ApplicationController
  before_action :authenticate_user!
  before_action :platform_admin?
  before_action :set_endpoint, only: %i[edit update]

  def index
    @endpoints = Endpoint.ordered_by_path.paginate(page: params[:page], per_page: 25)
  end

  def show
    @endpoint = Endpoint.includes(:parameter_references, :parameters).find(params[:id])
  end

  def new
    @endpoint = Endpoint.new
  end

  def create
    @endpoint = Endpoint.new(endpoint_params)

    if @endpoint.save
      flash[:success] = "Endpoint successfully created"
      redirect_to @endpoint
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @endpoint.update(endpoint_params)
      flash[:success] = "Endpoint successfully updated"
      redirect_to @endpoint
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def import
    if OpenAPIService::ImportService.new(params[:openapi_spec]).call
      redirect_to endpoints_path, notice: "Successfully imported endpoints"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_endpoint
    @endpoint = Endpoint.find(params[:id])
  end

  def endpoint_params
    params.require(:endpoint).permit(:path, :method, :description)
  end
end
