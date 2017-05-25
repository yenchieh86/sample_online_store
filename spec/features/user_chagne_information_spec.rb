require 'rails_helper'

RSpec.feature 'User_change_information' do
  let!(:user) { create(:user) }
  
  feature 'only change username' do
    before do
      user.confirm
      log_in.sign_in(user.email, user.password)
      user_setpu_page.update('Abcdefg', user.email, 'newpassword', user.password)
    end
    
    scenario { expect(page).to have_css('.bg-success', text: 'Your account has been updated successfully.') }
    scenario { expect(page).to have_text('Hi Abcdefg, nice to see you again!') }
    scenario { expect(page).to have_current_path(root_path) }
  end
  
  feature 'change username and email' do
    before do
      user.confirm
      log_in.sign_in(user.email, user.password)
      user_setpu_page.update('Abcdefg', 'abcdefg@text.com', 'newpassword', user.password)
    end
    
    scenario { expect(page).to have_css('.bg-success',
                                        text: 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.') }
    scenario { expect(page).to have_text('Hi Abcdefg, nice to see you again!') }
    scenario { expect(page).to have_current_path(root_path) }
  end
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
    
    def log_in
      home.go
      header.sign_in
    end
    
    def user_show_page
      home.go
      header.user_setup
    end
    
    def user_setpu_page
      user_show_page.update_account_info
    end
end