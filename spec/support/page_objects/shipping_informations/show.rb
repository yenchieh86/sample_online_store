require_relative '../pages/base'

module PageObjects
  module ShippingInformations
    class Show < Base
      
      def change_destination
        click_link 'Change Destination'
        PageObjects::ShippingInformations::Edit.new
      end
      
    end
  end
end