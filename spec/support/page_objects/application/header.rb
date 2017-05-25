require_relative '../pages/base'

module PageObjects
  module Application
    class Header < Base
      def sign_in
        account_dropdown.click_link 'Sign In'
        PageObjects::Devise::Sessions::New.new
      end
      
      def sign_up
        account_dropdown.click_link 'Sign Up'
        PageObjects::Devise::Registrations::New.new
      end
      
      def user_setup
        account_dropdown.click_link 'Setting'
        PageObjects::Pages::UsersShowPage.new
      end
      
      def click_logo
        click_link "Yen's Store"
      end
      
      private
      
        def account_dropdown
          find '.navbar .dropdown', text: 'Account'
        end
    end
  end
end