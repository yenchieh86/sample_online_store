class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_role!, only: [:update, :destroy]
  before_action :check_order_status!, only: [:update, :destroy]
  
  def create
    unpaid_order = current_user.orders.find_by(status: 'unpaid') || current_user.orders.create(tax: 0.08)
    order_item = unpaid_order.order_items.new(order_item_params)
    item = Item.friendly.find(params[:item_id])
    order_item.item_id = item.id
    
    order_item_update(order_item, item)
    
    if order_item.save
      update_order_data(unpaid_order, order_item.reload, '+=')
      unpaid_order.save
      flash[:success] = 'You have added it into your cart.'
      redirect_to category_item_url(item.category, item)
    else
      flash.now[:alert] = order_item.errors.full_messages
      render :back
    end
  end
  
  def update
    order_item = OrderItem.find(params[:id])
    order = order_item.order
    item = order_item.item
    old_data = Hash.new
    
    update_order_data(order, order_item, '-=')
    set_up_old_data_value(old_data, order_item)
    
    if params[:order_item][:quantity].to_i == 0
      if order_item.destroy
        if order.save
          flash[:success] = 'Your order has been deleted.'
          redirect_to order_url(order)
        else
          new_order_item = OrderItem.new
          restore_order_item_data(new_order_item, old_data)
          new_order_item.save
          flash.now[:alert] = order.errors.full_messages
          render order_path(order)
        end
      else
        flash.now[:alert] = order_item.errors.full_messages
        render order_path(order)
      end
    else
      order_item.quantity = params[:order_item][:quantity]
      order_item_update(order_item, item)
      update_order_data(order, order_item, '+=')
      
      if order_item.save
        if order.save
          flash[:success] = 'Your order has been updated.'
          redirect_to order_url(order)
        else
          restore_order_item_data(order_item, old_data)
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
    
    update_order_data(order, order_item, '-=')
    order.save
    
    if order_item.destroy
      flash[:success] = 'Order has been updated.'
      redirect_to order_url(order)
    else
      update_order_data(order, order_item, '+=')
      order.save
      flash.now[:alert] = order_item.errors.full_messages
      render order_path(order)
    end
    
  end
  
  private
  
    def order_item_params
      params.require(:order_item).permit(:quantity)
    end
    
    def check_order_status!
      order_item = OrderItem.find_by(id: params[:id])
      if order_item == nil && order_item.order.status != 'unpaid'
        flash[:alert] = "You can't change order's information after you made the payment. Please contact us if you have any question."
        redirect_to user_orders_path(current_user)
      end
    end
    
    def check_user_role!
      order_item = OrderItem.find_by(id: params[:id])
      if !current_user.admin? && current_user != order_item.order.user
        flash[:alert] = "You can't change other user's order."
        redirect_to root_url
      end
    end
    
    def update_order_data(order, order_item, operator)
      if operator == '+='
        order.total_weight += order_item.total_weight
        order.total_dimensions += order_item.total_dimensions
        order.order_items_total += order_item.total_amount
        order.shipping += order_item.shipping
        order.order_total_amount = order.order_items_total * ( 1.0 + order.tax) + order.shipping
      else
        order.total_weight -= order_item.total_weight
        order.total_dimensions -= order_item.total_dimensions
        order.order_items_total -= order_item.total_amount
        order.shipping -= order_item.shipping
      end
    end
    
    def order_item_update(order_item, item)
      order_item.item_id = item.id
      order_item.total_weight = item.weight * order_item.quantity
      order_item.total_dimensions = order_item.quantity * item.length * item.width * item.height
      order_item.total_amount = item.price * order_item.quantity
      order_item.shipping = item.shipping * order_item.quantity
    end
    
    def set_up_old_data_value(old_data, order_item)
      old_data = { order_id: order_item.order_id, item_id: order_item.item_id,
                   quantity: order_item.quantity, total_weight: order_item.total_weight,
                   total_dimensions: order_item.total_dimensions, total_amount: order_item.total_amount,
                   shipping: order_item.shipping }
    end
    
    def restore_order_item_data(new_order_item, old_data)
      new_order_item.update(order_id: old_data[:order_id], item_id: old_data[:item_id],
                           quantity: old_data[:quantity], total_weight: old_data[:total_weight],
                           total_amount: old_data[:total_amount], total_dimensions: old_data[:total_dimensions],
                           shipping: old_data[:shipping])
    end
end

