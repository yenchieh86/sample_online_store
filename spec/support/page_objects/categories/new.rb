require_relative '../pages/base'

module PageObjects
  module Categories
    class New < Base
      
      def create(title, description)
        fill_form(:user, { title: title, description: description } )
        click_button 'Create'
      end
      
    end
  end
end