class OrdersController < ApplicationController
  before_action :user_signed_in?
  
  def index
    if current_user.admin?
      @user = User.includes(:orders).friendly.find(params[:user_id])
    else
      @user = current_user.includes(:orders)
    end
  end

  def show
  end
  
  
end
