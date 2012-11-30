require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @asset = Factory(:asset)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing asset ID' do
        setup do
          get :show, :id => @asset.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent asset ID' do
        setup do
          get :show, :id => 0
        end
        should_redirect_to('home page') { root_url }
      end
    end
    
    context 'on GET to :new' do
      setup do
        get :new
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on GET to :edit' do
      setup do
        get :edit, :id => @asset.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :asset => Factory.attributes_for(:asset)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @asset.id, :asset => Factory.attributes_for(:asset)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @asset.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in, active user' do
    setup do
      @user = Factory(:user)
      @user.confirm_email!
      @user.activate
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @asset = Factory(:asset)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:assets)
      end
      
      context 'on GET to :show' do
        context 'with existing asset ID' do
          setup do
             get :show, :id => @asset.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:asset)
        end
        context 'with non-existent asset ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that asset"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:asset)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :asset => Factory.attributes_for(:asset)
          end
          should_set_the_flash_to 'Successfully created asset.'
          should_redirect_to('the asset') { asset_url(assigns(:asset)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :asset => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @asset.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:asset)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @asset.id, :asset => Factory.attributes_for(:asset)
          end
          should_set_the_flash_to 'Successfully updated asset.'
          should_redirect_to('the asset') { asset_url(assigns(:asset)) }
          should_assign_to(:asset)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @asset.id, :asset => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:asset)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @asset.id
        end
        should_set_the_flash_to 'Successfully destroyed asset.'
        should_redirect_to('the asset index') { assets_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user = Factory(:user)
        @user.confirm_email!
        @user.activate
        @user.add_role('executive')
        @controller.current_user = @user
        @asset = Factory(:asset)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:assets)
      end

      context 'on GET to :show' do
        context 'with existing asset ID' do
          setup do
             get :show, :id => @asset.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:asset)
        end
        context 'with non-existent asset ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that asset"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :asset => Factory.attributes_for(:asset)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :asset => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @asset.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @asset.id, :asset => Factory.attributes_for(:asset)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @asset.id, :asset => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @asset.id
        end
        should_redirect_to('home page') { root_url }
      end

    end
  end
  
    # context "create action" do
    #   should "render new template when model is invalid" do
    #     Asset.any_instance.stubs(:valid?).returns(false)
    #     post :create
    #     assert_template 'new'
    #   end
    #   
    #   should "redirect when model is valid" do
    #     Asset.any_instance.stubs(:valid?).returns(true)
    #     post :create
    #     assert_redirected_to asset_url(assigns(:asset))
    #   end
    # end
    #
    # context "update action" do
    #   should "render edit template when model is invalid" do
    #     Asset.any_instance.stubs(:valid?).returns(false)
    #     put :update, :id => Asset.first
    #     assert_template 'edit'
    #   end
    # 
    #   should "redirect when model is valid" do
    #     Asset.any_instance.stubs(:valid?).returns(true)
    #     put :update, :id => Asset.first
    #     assert_redirected_to asset_url(assigns(:asset))
    #   end
    # end
    # 
    # context "destroy action" do
    #   should "destroy model and redirect to index action" do
    #     asset = Asset.first
    #     delete :destroy, :id => asset
    #     assert_redirected_to assets_url
    #     assert !Asset.exists?(asset.id)
    #   end
    # end
end
