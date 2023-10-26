class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @developer_apps = current_user.developer_apps.order("created_AT DESC").paginate(page: params[:page])
    end
  end
end
