class ChargesController < ApplicationController
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
    if charge.status == 'succeeded'
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
      unless order.order_total_amount > 0.0
        flash[:alert] = "You don't have any item in this order yet."
        redirect_to user_orders_path(current_user)
      end
    end
end