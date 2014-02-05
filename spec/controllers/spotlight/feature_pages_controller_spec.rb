require 'spec_helper'
describe Spotlight::FeaturePagesController do
  routes { Spotlight::Engine.routes }

  # This should return the minimal set of attributes required to create a valid
  # Page. As you add validations to Page, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "title" => "MyString" } }
  describe "when signed in as a curator" do
    let(:user) { FactoryGirl.create(:exhibit_curator) }
    before {sign_in user }

    describe "GET index" do
      let!(:page) { FactoryGirl.create(:feature_page) }
      it "assigns all feature pages as @pages and @feature_pages" do
        get :index, exhibit_id: Spotlight::Exhibit.default
        expect(assigns(:feature_pages)).to include page
        expect(assigns(:pages)).to include page
        expect(assigns(:exhibit)).to eq Spotlight::Exhibit.default
      end
    end

    describe "GET show" do
      let(:page) { FactoryGirl.create(:feature_page) }
      it "assigns the requested page as @page and @feature_page" do
        get :show, exhibit_id: page.exhibit.id, id: page
        assigns(:feature_page).should eq(page)
        assigns(:page).should eq(page)
      end
    end

    describe "GET new" do
      it "assigns a new page as @page and @feature_page" do
        get :new, exhibit_id: Spotlight::Exhibit.default
        [:page, :feature_page].each do |type|
          expect(assigns(type)).to be_a_new(Spotlight::FeaturePage)
          expect(assigns(type).exhibit).to eq Spotlight::Exhibit.default
        end
      end
    end

    describe "GET edit" do
      let(:page) { FactoryGirl.create(:feature_page) }
      it "assigns the requested page as @page and @feature_page" do
        get :edit, exhibit_id: page.exhibit.id,id: page.id
        expect(assigns(:page)).to eq page
        expect(assigns(:feature_page)).to eq page
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Page" do
          expect {
            post :create, feature_page: {title: "MyString"} , exhibit_id: Spotlight::Exhibit.default
          }.to change(Spotlight::FeaturePage, :count).by(1)
        end

        it "assigns a newly created page as @page and @feature_page" do
          post :create, feature_page: {title: "MyString"}, exhibit_id: Spotlight::Exhibit.default
          [:page, :feature_page].each do |type|
            assigns(type).should be_a(Spotlight::FeaturePage)
            assigns(type).should be_persisted
          end
        end

        it "redirects to the created page" do
          post :create, feature_page: {title: "MyString"}, exhibit_id: Spotlight::Exhibit.default
          response.should redirect_to([Spotlight::FeaturePage.last.exhibit, Spotlight::FeaturePage.last])
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved page as @page and @feature_page" do
          # Trigger the behavior that occurs when invalid params are submitted
          Spotlight::FeaturePage.any_instance.stub(:save).and_return(false)
          post :create, feature_page: { "title" => "invalid value" }, exhibit_id: Spotlight::Exhibit.default
          assigns(:page).should be_a_new(Spotlight::FeaturePage)
          assigns(:feature_page).should be_a_new(Spotlight::FeaturePage)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Spotlight::FeaturePage.any_instance.stub(:save).and_return(false)
          post :create, feature_page: { "title" => "invalid value" }, exhibit_id: Spotlight::Exhibit.default
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      let(:page) { FactoryGirl.create(:feature_page) }
      describe "with valid params" do
        it "updates the requested page" do
          # Assuming there are no other pages in the database, this
          # specifies that the Page created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Spotlight::FeaturePage.any_instance.should_receive(:update).with(valid_attributes)
          put :update, id: page, exhibit_id: page.exhibit.id, feature_page: valid_attributes
        end

        it "assigns the requested page as @page and @feature_page" do
          put :update, id: page, exhibit_id: page.exhibit.id, feature_page: valid_attributes
          assigns(:page).should eq(page)
          assigns(:feature_page).should eq(page)
        end

        it "redirects to the page" do
          put :update, id: page, exhibit_id: page.exhibit.id, feature_page: valid_attributes
          response.should redirect_to([page.exhibit, page])
        end
      end

      describe "with invalid params" do
        it "assigns the page as @page and @feature_page" do
          # Trigger the behavior that occurs when invalid params are submitted
          Spotlight::FeaturePage.any_instance.stub(:save).and_return(false)
          put :update, id: page, exhibit_id: page.exhibit.id, feature_page: { "title" => "invalid value" }
          assigns(:page).should eq(page)
          assigns(:feature_page).should eq(page)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Spotlight::FeaturePage.any_instance.stub(:save).and_return(false)
          put :update, id: page, exhibit_id: page.exhibit.id, feature_page: { "title" => "invalid value" }
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:page) { FactoryGirl.create(:feature_page) }
      it "destroys the requested page" do
        expect {
          delete :destroy, id: page, exhibit_id: page.exhibit.id
        }.to change(Spotlight::FeaturePage, :count).by(-1)
      end

      it "redirects to the pages list" do
        delete :destroy, id: page, exhibit_id: page.exhibit.id
        response.should redirect_to(exhibit_feature_pages_path(page.exhibit))
      end
    end
  end
end
