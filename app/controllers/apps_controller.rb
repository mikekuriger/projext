class AppsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @apps = App.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @app.save
      flash[:notice] = "Successfully created app."
      redirect_to @app
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @app.update_attributes(params[:app])
      flash[:notice] = "Successfully updated app."
      redirect_to @app
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @app.destroy
    flash[:notice] = "Successfully destroyed app."
    redirect_to apps_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that app"
    redirect_to root_url
  end
end
