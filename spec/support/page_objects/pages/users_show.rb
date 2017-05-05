require_relative 'base'

module PageObjects
  module Pages
    class UsersShowPage < Base
      
      def update_account_info
        click_link 'Change Account Information'
        PageObjects::Devise::Registrations::Edit.new
      end
      
    end
  end
end