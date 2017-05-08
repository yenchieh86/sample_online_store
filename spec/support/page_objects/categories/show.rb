require_relative '../pages/base'

module PageObjects
  module Categories
    class Show < Base
      
      def go(category)
        visit "/categories/#{category.id}"
      end
      
    end
  end
end