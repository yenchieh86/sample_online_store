class OrderItemsController < ApplicationController
  before_action :user_signed_in?
  before_action :check_order_status!, only: [:update, :destroy]
  
  def index
  end

  def show
  end
  
  def create
    unpaid_order = current_user.orders.find_by(status: 'unpaid') || current_user.orders.create(tax: 0.08)
    
    order_item = unpaid_order.order_items.new(order_item_params)
    order_item.total_weight = params[:order_item][:item_weight].to_f * order_item.quantity
    order_item.total_dimensions = params[:order_item][:quantity].to_f *
                                  params[:order_item][:item_length].to_f *
                                  params[:order_item][:item_width].to_f *
                                  params[:order_item][:item_height].to_f
    order_item.total_amount = params[:order_item][:item_price].to_f * order_item.quantity
    order_item.shipping = params[:order_item][:item_shipping].to_f * order_item.quantity
    
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
  
  def update
    order_item = OrderItem.find(params[:id])
    order = order_item.order
    item = order_item.item
    
    order.total_weight -= order_item.total_weight
    order.total_dimensions -= order_item.total_dimensions
    order.order_items_total -= order_item.total_amount
    order.shipping -= order_item.shipping
    order.order_total_amount = order.order_items_total * (order.tax + 1.0) + order.shipping

    if params[:order_item][:quantity].to_i == 0
      old_data = { order_id: order_item.order_id, item_id: order_item.item_id,
                   quantity: order_item.quantity, total_weight: order_item.total_weight,
                   total_dimensions: order_item.total_dimensions, total_amount: order_item.total_amount,
                   shipping: order_item.shipping }
      if order_item.destroy
        if order.save
          flash[:success] = 'Your order has been updated.'
          redirect_to order_url(order)
        else
          OrderItem.create(order_id: old_data[:order_id], item_id: old_data[:item_id],
                           quantity: old_data[:quantity], total_weight: old_data[:total_weight],
                           total_amount: old_data[:total_amount], total_dimensions: old_data[:total_dimensions],
                           shipping: old_data[:shipping])
          flash.now[:alert] = order.errors.full_messages
          render order_path(order)
        end
      else
        flash.now[:alert] = order_item.errors.full_messages
        render order_path(order)
      end
    else
      old_data = { quantity: order_item.quantity, total_weight: order_item.total_weight,
                   total_dimensions: order_item.total_dimensions, total_amount: order_item.total_amount,
                   shipping: order_item.shipping}
  
      order_item.quantity = params[:order_item][:quantity]
      order_item.total_weight = item.weight * order_item.quantity
      order_item.total_dimensions = order_item.quantity.to_f * item.length * item.width * item.height
      order_item.total_amount = item.price * order_item.quantity
      order_item.shipping = item.shipping * order_item.quantity
      
      order.total_weight += order_item.total_weight
      order.total_dimensions += order_item.total_dimensions
      order.order_items_total += order_item.total_amount
      order.shipping += order_item.shipping
      order.order_total_amount = order.order_items_total * (order.tax + 1.0) + order.shipping
      
      if order_item.save
        if order.save
          flash[:success] = 'Your order has been updated.'
          redirect_to order_url(order)
        else
          order_item.quantity = old_data[:quantity]
          order_item.total_weight = old_data[:total_weight]
          order_item.total_dimensions = old_data[:total_dimensions]
          order_item.total_amount = old_data[:total_amount]
          order_item.shipping = old_data[:shipping]
          order_item.save
          
          flash.now[:alert] = order.errors.full_messages
          render order_path(order)
        end
      else
        flash.now[:alert] = order_item.errors.full_messages
        render order_path(order)
      end
    end
  end
  
  def destroy
    order_item = OrderItem.find(params[:id])
    
    order = Order.find(order_item.order_id)
    
    order.total_weight -= order_item.total_weight
    order.total_dimensions -= order_item.total_dimensions
    order.order_items_total -= order_item.total_amount
    order.shipping -= order_item.shipping
    order.order_total_amount = order.order_items_total * (order.tax + 1.0) + order.shipping
    order.save
    
    if order_item.destroy
      flash[:success] = 'Your order has been updated.'
      redirect_to order_url(order)
    else
      order_update(order, order_item)
      flash.now[:alert] = order_item.errors.full_messages
      render order_path(order)
    end
    
  end
  
  private
  
    def check_order_status!
      order = OrderItem.find(params[:id]).order
      if order.status != 'unpaid'
        flash[:alert] = "This order can't be changed after your made the payment.\n Please contact us if you have any question."
        redirect_to user_orders_path(current_user)
      end
    end
  
    def order_item_params
      params.require(:order_item).permit(:quantity, :item_id)
    end
    
    def order_update(order, order_item)
      order.total_weight += order_item.total_weight
      order.total_dimensions += order_item.total_dimensions
      order.order_items_total += order_item.total_amount
      order.shipping += order_item.shipping
      order.order_total_amount = order.order_items_total * (order.tax + 1.0) + order.shipping
      order.save
    end
  
end

