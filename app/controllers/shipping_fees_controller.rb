class ShippingFeesController < ApplicationController
  def show
    company = params[:company]
    if company != nil
      
      uri = URI('http://production.shippingapis.com/ShippingAPI.dll?API=RateV4&XML=<RateV4Request USERID="' + ENV['USPS_USER_ID'] + '"><Revision>2</Revision><Package ID="1ST"><Service>Priority</Service><ZipOrigination>44106</ZipOrigination><ZipDestination>20770</ZipDestination><Pounds>0</Pounds><Ounces>3.12345678</Ounces><Container>MD FLAT RATE BOX</Container><Size>REGULAR</Size></Package></RateV4Request>')
      result = Net::HTTP.get(uri)
      if result.include?('<Error>')
        @error = result.scan(/<Description>.+Description>/).map { |word| word.sub(/<Description>/, '').sub(/<.Description>/, '') }.join("\n")
      else
        @price = result.scan(/<Rate>.+Rate>/)[0].sub(/<Rate>/, '').sub(/<.Rate>/, '').to_f + 8
        all_services = result.scan(/<SpecialServices>.+SpecialServices>/).map { |word| word.sub(/<SpecialServices>/, '').sub(/<.SpecialServices>/, '') }.join("\n")
        @id = all_services.scan(/<ServiceID>[^<]+/).map { |word| word.sub(/<ServiceID>/, '') }
        @service_name = all_services.scan(/<ServiceName>[^<]+/).map { |word| word.sub(/<ServiceName>/, '') }
        @available = all_services.scan(/<Available>[^<]+/).map { |word| word.sub(/<Available>/, '') }
        @service_price = all_services.scan(/<Price>[^<]+/).map { |word| word.sub(/<Price>/, '') }
        @services_array = @service_name.size
      end
    end
  end
end


