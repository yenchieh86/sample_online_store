module ApplicationHelper
  def navbar_category_list
    Category.all
  end
end
