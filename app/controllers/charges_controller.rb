class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :order_has_destination?
  before_action :check_order_total_amount!
  
  def new
    @order = Order.find(params[:order_id])
  end
  
  def create
    order = Order.find(params[:order_id])
    @amount = (order.order_total_amount * 100).to_i
    
    customer = Stripe::Customer.create(email: params[:stripeEmail], source: params[:stripeToken])
    charge = Stripe::Charge.create(customer: customer.id, amount: @amount,
                                   description: "Customer: #{current_user.email}, Order: #{order.id}",
                                   currency: 'usd')
    if charge.paid?
      order.update(status: 'unshipped')
      flash[:success] = 'Thank you. You can track your package after we send it.'
      redirect_to user_orders_path(current_user)
    else
      flash[:alert] = 'The payment is not complete.'
      redirect_to user_orders_path(current_user)
    end
    
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_charge_path(order)
    
  end
  
  private
  
    def check_order_total_amount!
      order = Order.find(params[:order_id])
      unless order.order_total_amount > 0.00
        flash[:alert] = "You don't have any item in this order yet."
        redirect_to order_url(order)
      end
    end
    
    def order_has_destination?
      order = Order.find(params[:order_id])
      if order.shipping_information == nil
        flash[:notice] = "Please enter the destination"
        redirect_to new_order_shipping_information_url(order)
      end
    end
end
