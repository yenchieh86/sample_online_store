require_relative '../../pages/base'

module PageObjects
  module Devise
    module Registrations
      class New < Base
        
        def sign_up(email, password, password_confirmation)
          fill_form(:user, { email: email, password: password, password_confirmation: password_confirmation } )
          click_button 'Sign up'
        end
        
      end
    end
  end
end