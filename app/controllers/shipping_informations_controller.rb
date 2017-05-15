class ShippingInformationsController < ApplicationController
  before_action :check_user!
  before_action :check_order_status!, except: [:show]
  
  def show
    @shipping_information = ShippingInformation.includes(:order).find(params[:id])
  end

  def new
    @shipping_information = Order.find(params[:order_id]).build_shipping_information
  end

  def create
    @shipping_information = Order.find(params[:order_id]).build_shipping_information(firmname: params[:shipping_information][:firmname], address1: params[:shipping_information][:address1],
                   address2: params[:shipping_information][:address2], city: params[:shipping_information][:city], state: params[:shipping_information][:state],
                   zip5: params[:shipping_information][:zip5], zip4: params[:shipping_information][:zip4])
                   
    check_address_from_usps('new', @shipping_information, @shipping_information.firmname, @shipping_information.address1, @shipping_information.address2,
                            @shipping_information.city, @shipping_information.state, @shipping_information.zip5, @shipping_information.zip4,
                            'The address has been saved, please double check before you make the payment.')
  end
  
  def edit
    @shipping_information = ShippingInformation.find(params[:id])
  end

  def update
    @shipping_information = ShippingInformation.find(params[:id])
    
    check_address_from_usps('edit', @shipping_information, params[:shipping_information][:firmname], params[:shipping_information][:address1],
                             params[:shipping_information][:address2], params[:shipping_information][:city], params[:shipping_information][:state],
                             params[:shipping_information][:zip5], params[:shipping_information][:zip4],
                             'The address has been changed, please double check before you make the payment.')
  end
  
  private
  
    def check_user!
      order = Order.find(params[:order_id])
      if current_user != order.user
        flash[:alert] = "You can't access to other user's order information."
        redirect_to root_url
      end
    end
  
    def check_order_status!
      order = Order.find(params[:order_id])
      if !order.unpaid?
        flash.now[:alert] = "You can't change this order's destination, please contact us if you have any question."
        render order_path(order)
      end
    end
    
    def check_address_from_usps(path, object, object_firmname, object_address1,object_address2, object_city, object_state, object_zip5, object_zip4, message)
      uri = URI('http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID="' + 
                 ENV['USPS_USER_ID'] + '"><IncludeOptionalElements>true</IncludeOptionalElements><ReturnCarrierRoute>true</ReturnCarrierRoute><Address ID="0">' +
                 '<FirmName></FirmName><Address1></Address1><Address2>' + object_address2 + '</Address2><City>' + object_city + '</City><State>' + object_state + '</State>' +
                 '<Zip5></Zip5><Zip4></Zip4></Address></AddressValidateRequest>')
      result = Net::HTTP.get(uri)
      
      if result.include?('<Error>')
        flash.now[:alert] = result.scan(/<Description>.+Description>/).map { |word| word.sub(/<Description>/, '').sub(/<.Description>/, '') }.join("\n")
        render path
      else
        address2 = result.scan(/<Address2>.+Address2>/)[0].sub(/<Address2>/, '').sub(/<.Address2>/, '')
        zip5 = result.scan(/<Zip5>.+Zip5>/)[0].sub(/<Zip5>/, '').sub(/<.Zip5>/, '')
        zip4 = result.scan(/<Zip4>.+Zip4>/)[0].sub(/<Zip4>/, '').sub(/<.Zip4>/, '')
        delivery_point = result.scan(/<DeliveryPoint>.+DeliveryPoint>/)[0].sub(/<DeliveryPoint>/, '').sub(/<.DeliveryPoint>/, '')
        carrier_route = result.scan(/<CarrierRoute>.+CarrierRoute>/)[0].sub(/<CarrierRoute>/, '').sub(/<.CarrierRoute>/, '')
        if object_address2.downcase != address2.downcase
          flash.now[:alert] = 'Address is not match.'
          render path
        elsif object_zip5 != zip5
          flash.now[:alert] = '5 digit Zipcode is not match.'
          render path
        elsif !object_zip4.empty? && object_zip4 != zip4
          flash.now[:alert] = '4 digit Zipcode is not match.'
          render path
        else
          object.firmname = object_firmname.split(' ').map { |word| word.capitalize }.join(' ')
          object.address1 = object_address1
          object.address2 = address2.split(' ').map { |word| word.capitalize }.join(' ')
          object.city.capitalize!
          object.state.upcase!
          object.zip5 = zip5
          object.zip4 = zip4 if zip4 != nil
          object.delivery_point = delivery_point
          object.carrier_route = carrier_route
          object.save
          flash[:success] = message
          redirect_to order_shipping_information_url(object.order, object)
        end
      end
        
    end
end
