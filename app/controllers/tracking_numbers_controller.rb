class TrackingNumbersController < ApplicationController

  def show
    order = Order.find_by(id: params[:order_id])
    shipping_information = ShippingInformation.find_by(id: params[:id])
    
    if order.shipping_information == shipping_information
      tracking_id = shipping_information.tracking_number
      uri = URI('http://production.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=<TrackRequest USERID="' + ENV['USPS_USER_ID'] + '"><TrackID ID="' + tracking_id + '"></TrackID></TrackRequest>')
      result = Net::HTTP.get(uri)
      if result.include?('<Error>')
      @package_process = result.scan(/<Description>.+Description>/).map { |word| word.sub(/<Description>/, '').sub(/<.Description>/, '') }.split('.').join("")
      else
        @package_process = result.scan(/<TrackSummary>.+TrackSummary>/).map { |word| word.sub(/<TrackSummary>/, '').sub(/<.TrackSummary>/, '') }.join("")
        @package_process.concat(result.scan(/<TrackDetail>.+TrackDetail>/).map { |word| word.sub(/<TrackDetail>/, '').sub(/<.TrackDetail>/, '') }.join(""))
      end
    else
      flash.now[:alert] = 'Order and shipping information are not match.'
      render user_show_path(current_user)
    end
  end

  def new
    @shipping_information = Order.find_by(id: params[:order_id]).shipping_information
  end
  
  def create
    shipping_information = Order.find_by(id: params[:order_id]).shipping_information
    shipping_information.tracking_number = params[:tracking_number]
    if shipping_information.save
      shipping_information.order.update(status: 'unreceived')
      flash[:success] = 'Now, customer can track this package.'
      redirect_to user_list_url
    else
      flash.now[:alert] = shipping_information.errors.full_messages
      render 'new'
    end
  end
  
  def edit
    @shipping_information = Order.find_by(id: params[:order_id]).shipping_information
  end
  
  def update
    shipping_information = Order.find_by(id: params[:order_id]).shipping_information
    shipping_information.tracking_number = params[:tracking_number]
    if shipping_information.save
      flash[:success] = 'The tracking number has been updated.'
      redirect_to user_list_url
    else
      flash.now[:alert] = shipping_information.errors.full_messages
      render 'new'
    end
  end
end




  def track_package
    tracking_id = params[:tracking_id]
    uri = URI('http://production.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=<TrackRequest USERID="' + ENV['USPS_USER_ID'] + '"><TrackID ID="' + tracking_id + '"></TrackID></TrackRequest>')
    result = Net::HTTP.get(uri)
    @package_process = ''
    if result.include?('<Error>')
      @package_process = result.scan(/<Description>.+Description>/).map { |word| word.sub(/<Description>/, '').sub(/<.Description>/, '') }.join("\n")
    else
      @package_process = result.scan(/<TrackSummary>.+TrackSummary>/).map { |word| word.sub(/<TrackSummary>/, '').sub(/<.TrackSummary>/, '') }.join("\n")
      @package_process.concat(result.scan(/<TrackDetail>.+TrackDetail>/).map { |word| word.sub(/<TrackDetail>/, '').sub(/<.TrackDetail>/, '') }.join("\n"))
    end
  end