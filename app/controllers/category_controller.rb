class CategoryController < ApplicationController
  before_action :identify_admin!, only: [:new, :edit, :destroy]
  
  def index
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end
  
  private
  
    def identify_admin!
      current_user.role == 'admin'
    end
end
