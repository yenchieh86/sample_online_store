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
  
  def count_total_quantity(order)
    n = 0
    order.order_items.each do |order_item|
      n += order_item.quantity
    end
    n
  end
  
  def order_status_text_for_order_index(order)
    case order.status
      when 'unpaid'
        "<%= order.status %>".html_safe
      when 'unshipped'
        "Waiting for shipping"
      when 'unreceived'
        "Shipped"
      when 'finished'
        "Finished"
      else
        'Please contact us'
    end
  end
end
