require 'rails_helper'

RSpec.feature 'User_signup' do
  scenario 'should send confirmation email after user sign_up' do
    home.go
    expect { user_sign_up_page.sign_up 'test@example.com', '111111', '111111' }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
    
    def user_sign_up_page
      header.sign_up
    end
end