class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    if current_user.admin?
      @user = User.friendly.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def list
    if current_user.admin?
      @users = User.includes(:orders).all
      @orders = Order.all
    else
      flash[:alert] = 'You can not access to user list page.'
      redirect_to root_url
    end
  end
  
  def erase
    if !current_user.admin?
      flash[:alert] = "You can't use this feature."
      redirect_to root_url
    else
      @user = User.friendly.find(params[:id])
      items = @user.items
      orders = @user.orders
      backup_user = User.find_by(username: 'backup')
      
      items.each do |item|
        item.update_attributes(user_id: backup_user.id)
      end
      
      orders.each do |order|
        order.update_attributes(user_id: backup_user.id)
      end
      
      if @user.destroy
        flash[:success] = 'You just delete an user.'
        redirect_to user_list_url
      else
        items.each do |item|
          item.update_attributes(user_id: @user.id)
        end
        flash.now[:alert] = @user.errors.full_messages
        render :list
      end
    end
  end
end
