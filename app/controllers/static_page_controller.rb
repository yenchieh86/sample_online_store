class StaticPageController < ApplicationController
  def home
    @categories = Category.all.includes(:items)
  end
  
end
