require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ImportsController do

  before (:each) do
    @user = build(:user)
    User.any_instance.stub(:padma_user).and_return(PadmaUser.new(:username => @user.username, :email => "test@test.com"))
    Account.any_instance.stub(:padma).and_return(PadmaAccount.new(:name => @user.current_account.name))
    User.any_instance.stub(:enabled_accounts).and_return([PadmaAccount.new(:name => @user.current_account.name)])
    User.any_instance.stub(:admin?).and_return(true)
    @user.save
    sign_in @user
  end

  describe "GET index" do
    it "assigns all imports as @imports" do
      import = create(:import, :account => @user.current_account)
      get :index, {}
      assigns(:imports).should eq([import])
    end
  end

  describe "GET show" do
    it "assigns the requested import as @import" do
      import = create(:import, :account => @user.current_account)
      get :show, {:id => import.to_param}
      assigns(:import).should eq(import)
    end
  end

  describe "GET new" do
    it "assigns a new import as @import" do
      get :new, {}
      assigns(:import).should be_a_new(Import)
    end
  end

  describe "GET edit" do
    it "assigns the requested import as @import" do
      import = create(:import, :account => @user.current_account)
      get :edit, {:id => import.to_param}
      assigns(:import).should eq(import)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Import" do
        expect {
          post :create, {:import => attributes_for(:import)}
        }.to change(Import, :count).by(1)
      end

      it "assigns a newly created import as @import" do
        post :create, {:import => attributes_for(:import)}
        assigns(:import).should be_a(Import)
        assigns(:import).should be_persisted
      end

      it "redirects to the created import" do
        post :create, {:import => attributes_for(:import)}
        response.should redirect_to(Import.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved import as @import" do
        # Trigger the behavior that occurs when invalid params are submitted
        Import.any_instance.stub(:save).and_return(false)
        post :create, {:import => {  }}
        assigns(:import).should be_a_new(Import)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Import.any_instance.stub(:save).and_return(false)
        post :create, {:import => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested import" do
        import = create(:import, :account => @user.current_account)
        # Assuming there are no other imports in the database, this
        # specifies that the Import created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Import.any_instance.should_receive(:update).with({ "these" => "params" })
        put :update, {:id => import.to_param, :import => { "these" => "params" }}
      end

      it "assigns the requested import as @import" do
        import = create(:import, :account => @user.current_account)
        put :update, {:id => import.to_param, :import => attributes_for(:import)}
        assigns(:import).should eq(import)
      end

      it "redirects to the import" do
        import = create(:import, :account => @user.current_account)
        put :update, {:id => import.to_param, :import => attributes_for(:import)}
        response.should redirect_to(import)
      end
    end

    describe "with invalid params" do
      it "assigns the import as @import" do
        import = create(:import, :account => @user.current_account)
        # Trigger the behavior that occurs when invalid params are submitted
        Import.any_instance.stub(:save).and_return(false)
        put :update, {:id => import.to_param, :import => {  }}
        assigns(:import).should eq(import)
      end

      it "re-renders the 'edit' template" do
        import = create(:import, :account => @user.current_account)
        # Trigger the behavior that occurs when invalid params are submitted
        Import.any_instance.stub(:save).and_return(false)
        put :update, {:id => import.to_param, :import => {  }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested import" do
      import = create(:import, :account => @user.current_account)
      expect {
        delete :destroy, {:id => import.to_param}
      }.to change(Import, :count).by(-1)
    end

    it "redirects to the imports list" do
      import = create(:import, :account => @user.current_account)
      delete :destroy, {:id => import.to_param}
      response.should redirect_to(imports_url)
    end
  end

end
