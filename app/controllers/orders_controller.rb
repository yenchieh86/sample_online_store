class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user!, only: [:show, :receive]
  
  def index
    if current_user.admin?
      @user = User.includes(:orders).friendly.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def show
    @order = Order.includes(:user, :order_items).find(params[:id])
  end
  
  def receive
    order = Order.includes(:user, :order_items).find(params[:id])
    order.update(status: 'finished')
    flash[:success] = 'Thank you for shopping.'
    redirect_to user_orders_url(order.user)
  end
  
  private
  
    def check_user!
      order = Order.includes(:user).find(params[:id])
      
      unless current_user == order.user || current_user.admin?
        flash[:alert] = "You can't access to other user's order."
        redirect_to user_show_url(current_user)
      end
    end
    
end
