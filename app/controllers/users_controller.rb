class UsersController < ApplicationController
  load_and_authorize_resource :only => [ :index, :show, :new, :edit, :update, :destroy, :activate, :disable ]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request
  
  PER_PAGE = 30
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => PER_PAGE)
    
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@users, 'users.csv') }
      format.xml  { render :xml => @users }
      format.xml  { render :xml => @users }
      format.json { render :json => @users }
      format.yaml { send_data @users.to_yaml }
    end
  end

  def show
  end

  def edit
  end
  
  def update
    unauthorized! if ((params[:user][:roles] || params[:role_ids]) && cannot?(:assign_roles, @user))
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end
  
  def activate
    respond_to do |format|
      if @user.activate
        format.html {
          flash[:notice] = "Activated user."
          redirect_to users_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@user, 'row'), :partial => "user", :object => @user
          end
        }
        format.xml  { render :xml => @user }
      else
        format.html { render :action => "edit" }
        format.js   { render @user.errors, :status => 500 }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def disable
    respond_to do |format|
      if @user.disable
        format.html {
          flash[:notice] = "Disabled user."
          redirect_to users_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@user, 'row'), :partial => "user", :object => @user
          end
        }
        format.xml  { render :xml => @user }
      else
        format.html { render :action => "edit" }
        format.js   { render @user.errors, :status => 500 }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that user"
    redirect_to root_url
  end
end
