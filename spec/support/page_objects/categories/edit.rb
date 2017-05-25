require_relative '../pages/base'

module PageObjects
  module Categories
    class Edit < Base
      
      def update(title, description)
        fill_form(:category, { title: title, description: description})
        click_button 'Update'
      end
      
    end
  end
end