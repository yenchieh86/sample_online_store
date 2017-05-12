class OrderItemsController < ApplicationController
  before_action :user_signed_in?
  
  def index
  end

  def show
  end
  
  def create
    unpaid_order = current_user.orders.find_by(status: 'unpaid') || current_user.orders.create
    
    order_item = unpaid_order.order_items.new(order_item_params)
    order_item.total_weight = params[:order_item][:item_weight].to_f * order_item.quantity
    order_item.total_dimensions = params[:order_item][:quantity].to_f *
                                  params[:order_item][:item_length].to_f *
                                  params[:order_item][:item_width].to_f *
                                  params[:order_item][:item_height].to_f
    order_item.total_amount = params[:order_item][:item_price].to_f * order_item.quantity
    
    if order_item.save
      order_update(unpaid_order, order_item.reload)
      flash[:success] = 'You have added it into your cart'
      redirect_to category_item_url(order_item.item.category, order_item.item.id)
    else
      flash.now[:alert] = order_item.errors.full_messages
      render :back
    end
  end

  def edit
  end
  
  private
  
    def order_item_params
      params.require(:order_item).permit(:quantity, :item_id)
    end
    
    def order_update(order, order_item)
      order.total_weight += order_item.total_weight
      order.total_dimensions += order_item.total_dimensions
      order.order_items_total += order_item.total_amount
      order.save
    end
  
end