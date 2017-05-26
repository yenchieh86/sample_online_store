require_relative '../pages/base'

module PageObjects
  module Items
    class Index < Base
    
      def edit(item)
        item_list_table(item).click_link 'Edit'
        PageObjects::Items::Edit.new
      end
      
      def delete(item)
        item_list_table(item).click_link 'Delete'
      end
      
      private
      
        def item_list_table(item)
          find "table tr.#{item.title.downcase}"
        end
    end
  end
end