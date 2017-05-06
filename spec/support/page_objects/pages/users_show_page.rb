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
        click_linl 'Add New Category'
        PageObjects::Category::New.new
      end
      
      private
      
        def header
          PageObjects::Application::Header.new
        end
    end
  end
end