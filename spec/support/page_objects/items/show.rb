require_relative '../pages/base'

module PageObjects
  module Items
    class Show < Base
      
      def order(amount)
        fill_form(:order_item, { quantity: amount } )
        click_button 'Order'
      end
      
    end
  end
end