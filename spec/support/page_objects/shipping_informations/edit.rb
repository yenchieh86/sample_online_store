require_relative '../pages/base'

module PageObjects
  module ShippingInformations
    class Edit < Base
      
      def update_destination(address)
        fill_form(:shipping_information, { 'FirmName' => address[:firmname], 'Apartment / Suite #' => address[:address1],
                                           'Address' => address[:address2], 'City' => address[:city],
                                           'State' => address[:state], '5 digit Zip Code' => address[:zip5],
                                           '4 digit Zip Code' => address[:zip4] })
        click_button "Check"
      end
      
    end
  end
end