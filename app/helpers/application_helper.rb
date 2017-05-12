module ApplicationHelper
  def navbar_category_list
    Category.all
  end
  
  def in_stock?(item)
    if @item.stock > 0
      "<span class='in_stock'>In Stock.</span>".html_safe
    else 
      "<span class='out_of_stock'>Out of Stock</span>".html_safe
    end 
  end
end
