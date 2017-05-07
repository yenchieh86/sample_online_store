require_relative '../pages/base'

module PageObjects
  module Application
    class Navbar < Base
      
      def category_show_page(category)
        account_dropdown.click_link "#{category.title}"
        PageObjects::Categories::Show.new
      end
      
      private
      
        def account_dropdown
          find '.navbar-left .dropdown', text: 'Categories List'
        end
    end
  end
end