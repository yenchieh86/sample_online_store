require_relative 'base'

module PageObjects
  module Pages
    class UsersShowPage < Base
      
      def update_account_info
        click_link 'Change Account Information'
        PageObjects::Devise::Registrations::Edit.new
      end
      
      def go
        header.user_setup
      end
      
      def category_new_page
        click_link 'Add New Category'
        PageObjects::Categories::New.new
      end
      
      def category_list
        click_link 'Category List'
        PageObjects::Categories::Index.new
      end
      
      def order_list
        click_link 'Order List'
        PageObjects::Orders::Index.new
      end
      
      def new_item
        click_link 'Add New Item'
        PageObjects::Items::New.new
      end
      
      private
      
        def header
          PageObjects::Application::Header.new
        end
    end
  end
end