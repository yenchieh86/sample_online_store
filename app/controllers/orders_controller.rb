class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.admin?
      @user = User.includes(:orders).friendly.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def show
    @order = Order.includes(:user, :order_items).find(params[:id])
    
    if current_user.admin?
      @order
    else
      if @order.user_id != current_user.id
        flash[:alert] = "You can't access to other user's order."
        redirect_to user_show_url(current_user)
      else
        @order
      end
    end
  end
end
