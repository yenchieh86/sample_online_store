class StaticPageController < ApplicationController
  def home
    @categories = Category.includes(:items).order(:title).page(params[:page]).per(3)
  end
  
end
