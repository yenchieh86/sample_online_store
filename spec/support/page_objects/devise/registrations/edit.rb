require_relative '../../pages/base'

module PageObjects
  module Devise
    module Registrations
      class Edit < Base
        
        def update(username, email, password, current_password)
          fill_form(:user, { username: username, email: email, password: password, password_confirmation: password, current_password: current_password } )
          click_button "Update"
        end
        
      end
    end
  end
end