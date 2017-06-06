class ItemsController < ApplicationController
  before_action :check_admin!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @category = Category.includes(:items).friendly.find(params[:category_id])
  end

  def show
    @item = Item.includes(:category).friendly.find(params[:id])
    @order_item = OrderItem.new
    @descriptions = @item.description.split('-')
  end

  def new
    @item = Item.new
    
    categories = Category.all 
    @category_list = Array.new
    categories.each do |category|
      @category_list.push([category.title, category.id])
    end
  end
  
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    
    if @item.save
      flash[:success] = 'The item was created.'
      redirect_to user_show_url(current_user)
    else
      categories = Category.all 
      @category_list = Array.new
      categories.each do |category|
        @category_list.push([category.title, category.id])
      end
      flash.now[:alert] = @item.errors.full_messages
      render :new
    end
  end

  def edit
    @item = Item.friendly.find(params[:id])
    
    if current_user.id == @item.user_id
      categories = Category.all
      @category_list = Array.new
      
      categories.each do |category|
        @category_list.push([category.title, category.id])
      end
    else
      flash[:alert] = 'You are not authorized to do that.'
      redirect_to root_url
    end
  end
  
  def update
    @item = Item.friendly.find(params[:id])
    if current_user.id == @item.user_id
      if @item.update_attributes(item_params)
        flash[:success] = 'The item has been updated'
        redirect_to category_item_url(@item.category, @item)
      else
        flash.now[:alert] = @item.errors.full_messages
        categories = Category.all 
        @category_list = Array.new
        categories.each do |category|
          @category_list.push([category.title, category.id])
        end
        render :edit
      end
    else
      flash[:alert] = 'You are not authorized to do that.'
      redirect_to root_url
    end
  end
  
  def destroy
    @item = Item.friendly.find(params[:id])
    
    if @item.destroy
      flash[:success] = 'Item has been destroyed.'
      redirect_to user_show_url(current_user)
    else
      flash[:alert] = @item.errors.full_messages
      redirect_to user_show_url(current_user)
    end
  end
  
  private
  
    def item_params
      params.require(:item).permit(:title, :description, :price, :stock,
                                   :weight, :length, :width, :height,
                                   :category_id, :status, :shipping, pictures: [])
    end
    
    def check_admin!
      if current_user == nil
        flash[:alert] = 'Please sign in first.'
        redirect_to new_user_session_url
      elsif !current_user.admin?
        flash[:alert] = 'You are not authorized to do that.'
        redirect_to root_url
      end
    end
end