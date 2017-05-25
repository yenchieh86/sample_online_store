require 'rails_helper'

RSpec.describe "static_page/home.html.erb" do
  let!(:category1) { create(:category) }
  let!(:category2) { create(:category) }
  let!(:item1) { create(:item) }
  let!(:item2) { create(:item) }
  
  before do
    category1.items = [item1, item2]
    category1.save
    @categories = Kaminari.paginate_array([category1, category2]).page(1)

    controller.singleton_class.class_eval do
      protected
      
        def current_user
          false
        end
        
        helper_method :current_user
    end
  end
  
  context 'unsigned_in_user' do
    it "should show Welcome to Yen's Shop" do
      render
      expect(rendered).to include("Welcome to Yen's Shop")
    end
    
    it "should show category list and items" do
      render
      expect(rendered).to include(category1.title)
      expect(rendered).to include(category2.title)
      expect(rendered).to include(item1.title)
      expect(rendered).to include(item2.title)
      expect(view).to render_template(:partial => "items/_item_show", :count => 2)
    end
  end
  
  context 'sign_in_user' do
    before do
      controller.singleton_class.class_eval do
        protected
        
          def current_user
            true
          end
          
          def username_capitalize!
            "Testuser"
          end
          
          helper_method :current_user
          helper_method :username_capitalize!
      end
    end
    
    it "should show greeting" do
      render
      expect(rendered).to include("Hi Testuser, nice to see you again!")
    end
    
    it "should show category list and items" do
      render
      expect(rendered).to include(category1.title)
      expect(rendered).to include(category2.title)
      expect(rendered).to include(item1.title)
      expect(rendered).to include(item2.title)
      expect(view).to render_template(:partial => "items/_item_show", :count => 2)
    end
  end
end