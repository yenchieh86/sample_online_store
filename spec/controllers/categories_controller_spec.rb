require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  
  describe 'not sign in user' do
    describe 'GET #index' do
      
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it 'should use category_index_template' do
        get :index
        expect(response).to render_template(:index)
      end
      
      it "should assigns @categories and render" do
        category1 = create(:category)
        category2 = create(:category)
        get :index
        expect(assigns(:categories)).to eq [category1, category2]
      end
    end
    
    describe "GET #show" do
      it "returns http success" do
        category1 = create(:category)
        get :show, params: { id: category1.reload.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:category)).to eq category1
      end
    end
    
    describe "GET #new" do
      it 'should redirect_to root_url' do
        get :new
        expect(response).to redirect_to(root_url)
      end
    end
    
    describe 'POST #create' do
      
      it 'should not create new category' do
        expect { post :create, params: { category: { title: 'Test', description: 'Test' } } }.to change(Category, :count).by(0)
      end
      
      it 'should redirect_to root_url page' do
        post :create, params: { category: { title: 'Test', description: 'Test' } }
        expect(response).to redirect_to(root_url)
      end
    end
    
    describe "GET #edit" do
      it "returns to root_url" do
        category1 = create(:category)
        get :edit, params: { id: category1.reload.id }
        expect(response).to redirect_to root_url
      end
    end
    
    describe "GET #update" do
      it "returns to root_url" do
        category1 = create(:category)
        patch :update, params: { id: category1.reload.id, category: { title: 'Test', description: 'Description' } }
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to root_url
      end
    end
  end
  
  describe 'standard_user' do
    let(:standard_user) { create(:user) }
    before do
      standard_user.skip_confirmation!
      standard_user.save
      sign_in standard_user
    end
    
    describe 'GET #index' do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it 'should use category_index_template' do
        get :index
        expect(response).to render_template(:index)
      end
      
      it "should assigns @categories and render" do
        category1 = create(:category)
        category2 = create(:category)
        get :index
        expect(assigns(:categories)).to eq [category1, category2]
      end
    end
    
    describe "GET #show" do
      it "returns http success" do
        category1 = create(:category)
        get :show, params: { id: category1.reload.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:category)).to eq category1
      end
    end
    
    describe "GET #new" do
      it 'should redirect_to root_url' do
        get :new
        expect(response).to redirect_to(root_url)
      end
    end
    
    describe 'POST #create' do
      
      it 'should not create new category' do
        expect { post :create, params: { category: { title: 'Test', description: 'Test' } } }.to change(Category, :count).by(0)
      end
      
      it 'should redirect_to root_url page' do
        post :create, params: { category: { title: 'Test', description: 'Test' } }
        expect(response).to redirect_to(root_url)
      end
    end
    
    describe "GET #edit" do
      it "returns to root_url" do
        category1 = create(:category)
        get :edit, params: { id: category1.reload.id }
        expect(response).to redirect_to root_url
      end
    end
    
    describe "GET #update" do
      it "returns to root_url" do
        category1 = create(:category)
        patch :update, params: { id: category1.reload.id, category: { title: 'Test', description: 'Description' } }
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to root_url
      end
    end
    
  end
  
  describe 'admin' do
    let(:admin) { create(:user) }
    before do
      admin.role = 'admin'
      admin.skip_confirmation!
      admin.save
      sign_in admin
    end
    
    describe 'GET #index' do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it 'should use category_index_template' do
        get :index
        expect(response).to render_template(:index)
      end
      
      it "should assigns @categories and render" do
        category1 = create(:category)
        category2 = create(:category)
        get :index
        expect(assigns(:categories)).to eq [category1, category2]
      end
    end
    
    describe 'GET #new' do
      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
    
    describe 'POST #create' do
      
      it 'should create new category' do
        expect { post :create, params: { category: { title: 'Test', description: 'Test' } } }.to change(Category, :count).by(1)
      end
      
      it 'should redirect_to category#index page after create new category' do
        post :create, params: { category: { title: 'Test', description: 'Test' } }
        expect(response).to redirect_to(categories_url)
      end
    end
    
    describe "GET #edit" do
      it "returns to root_url" do
        category1 = create(:category)
        get :edit, params: { id: category1.reload.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:category)).to eq category1
      end
    end
    
    describe "GET #update" do
      it "should update the category and returns to root_url" do
        category1 = create(:category)
        patch :update, params: { id: category1.reload.id, category: { title: 'Test', description: 'Description' } }
        expect(assigns(:category).title).to eq 'Test'
        expect(assigns(:category).description).to eq 'Description'
        expect(response).to redirect_to categories_url
      end
    end
  end
end
  
  
  

=begin
  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "GET #edit" do
    it "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end
=end

  

