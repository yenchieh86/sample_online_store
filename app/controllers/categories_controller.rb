class CategoriesController < ApplicationController
  before_action :identify_admin!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
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
  end
  
  def update
  end
  
  def destroy
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
