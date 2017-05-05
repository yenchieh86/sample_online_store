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
      
      private
      
        def header
          PageObjects::Application::Header.new
        end
    end
  end
end