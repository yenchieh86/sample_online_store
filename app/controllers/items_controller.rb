class ItemsController < ApplicationController
  before_action :check_admin!, only: [:new, :create, :edit, :update, :delete]
  
  def index
  end

  def show
    @item = Item.friendly.find(params[:id])
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
        redirect_to root_url
      else
        flash.now[:alert] = @item.errors.full_messages
        render :edit
      end
    else
      flash[:alert] = 'You are not authorized to do that.'
      redirect_to root_url
    end
  end
  
  def destroy
    @item = Item.friendly.find(params[:id])
    
    if current_user.id == @item.user_id
      if @item.destroy
        flash[:success] = 'Item has been destroyed.'
        redirect_to user_show_url(current_user)
      else
        flash[:alert] = @item.errors.full_messages
        redirect_to user_show_url(current_user)
      end
    else
      flash[:alert] = 'You are not authorized to do that.'
      redirect_to root_url
    end
  end
  
  private
  
    def item_params
      params.require(:item).permit(:title, :description, :price, :stock, :weight, :length, :width, :height, :category_id, :status)
    end
    
    def check_admin!
      unless current_user && current_user.admin?
        flash[:alert] = 'You are not authorized to do that.'
        redirect_to root_url
      end
    end
end