require_relative '../pages/base'

module PageObjects
  module Categories
    class Index < Base
      
      def show_item(category)
        if category.items_count > 1
          click_link "#{category.items.count} items"
        else
          click_link "#{category.items.count} item"
        end
        PageObjects::Items::Index.new
      end
      
      def edit
        click_link 'edit'
        PageObjects::Categories::Edit.new
      end
      
      def delete(category)
        category_list_table(category).click_link 'Delete'
      end
      
      private
      
        def category_list_table(category)
          find "table tr.#{category.title}"
        end
    end
  end
end