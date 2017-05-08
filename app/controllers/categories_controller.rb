class CategoriesController < ApplicationController
  before_action :identify_admin!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @items = Item.where(category_id: @category.id)
  end

  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    
    if @category.save
      flash[:success] = 'A category has been created.'
      redirect_to categories_url
    else
      flash.now[:error] = @category.errors.full_messages
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    
    if @category.update_attributes(category_params)
      flash[:success] = "You update the #{@category.title}'s information."
      redirect_to categories_url
    else
      flash[:alert] = @category.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    category = Category.find(params[:id])
    items = category.items
    backup_category = Category.where(title: 'Backup').first || Category.create(title: 'Backup', description: 'This category is for backup')
    
    items.each do |item|
      item.update_attributes(category_id: backup_category.id)
    end
    
    if category.destroy
      redirect_to root_url
    else
      items.each do |item|
        item.update_attributes(category_id: backup_category.id)
      end
      flash.now[:alert] = 'Someting is wrong.'
      render categories_url
    end
    
  end
  
  private
  
    def identify_admin!
      unless current_user && current_user.role == 'admin'
        flash[:alert] = 'You are not authorized to create new category.'
        redirect_to root_url
      end
    end
    
    def category_params
      params.require(:category).permit(:title, :description)
    end
end
