require 'rails_helper'

RSpec.describe "layouts/_header.html.erb" do
 
  describe 'unsigned_in_user' do
    before do
     controller.singleton_class.class_eval do
        protected
        
          def current_user
            false
          end
          
          helper_method :current_user
      end
    end
    
    it 'should have sign_in and sign_up link tag' do
      render
      expect(rendered).to include('Sign In')
      expect(rendered).to include('Sign Up')
    end
  end
  
  describe 'signed_in_user' do
    before do
      controller.singleton_class.class_eval do
        protected
        
          def current_user
            true
          end
          helper_method :current_user
      end
    end
    
    context "don't have unpaid order" do 
      before do
        controller.singleton_class.class_eval do
          protected
          
            def current_user_has_any_unpaid_order?
              false
            end
            
            helper_method :current_user_has_any_unpaid_order?
        end
      end
    
      it "should have setting and sign_out link, but don't have make_the_payment link" do
        render
        expect(rendered).to include('Setting')
        expect(rendered).to include('Sign Out')
        expect(rendered).not_to include('Make the Payment')
      end
    end
    
    context "have unpaid order" do
      before do
        controller.singleton_class.class_eval do
          protected
          
            def current_user_has_any_unpaid_order?
              true
            end
            
            helper_method :current_user_has_any_unpaid_order?
        end
      end
      
      it 'should have make_the_payment link' do
        render
        expect(rendered).to include("Make the Payment")
      end
    end
  end
end

