require_relative '../../pages/base'

module PageObjects
  module Devise
    module Registrations
      class New < Base
        
        def sign_up(username, email, password)
          fill_form(:user, { username: username, email: email, password: password, password_confirmation: password } )
          click_button 'Sign up'
        end
        
      end
    end
  end
end