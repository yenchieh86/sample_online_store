require_relative '../pages/base'

module PageObjects
  module Orders
    class Index < Base
      
      def select_an_order(order)
        order_list_table(order).click_link "#{order.order_items_count}"
        PageObjects::Orders::Show.new
      end
      
      def create_shipping_destination(order)
        order_list_table(order).click_link 'Create Destination'
        PageObjects::ShippingInformations::New.new
      end
      
      def show_destination(order)
        order_list_table(order).click_link 'Show Destination'
        PageObjects::ShippingInformations::Show.new
      end
      
      def make_the_payment(order)
        order_list_table(order).click_link 'Make the Payment'
      end
      
      private
      
        def order_list_table(order)
          find "table tr.order_id_#{order.id}"
        end
      
    end
  end
end