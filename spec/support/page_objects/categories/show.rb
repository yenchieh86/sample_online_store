require_relative '../pages/base'

module PageObjects
  module Categories
    class Show < Base
      
      def go(category)
        visit "/categories/#{category.id}"
      end
      
      def select_a_item(item)
        click_link "#{item.title}"
        PageObjects::Items::Show.new
      end
      
    end
  end
end