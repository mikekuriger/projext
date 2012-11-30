class MediaController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @media = Medium.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @medium.save
      flash[:notice] = "Successfully created medium."
      redirect_to @medium
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @medium.update_attributes(params[:medium])
      flash[:notice] = "Successfully updated medium."
      redirect_to @medium
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @medium.destroy
    flash[:notice] = "Successfully destroyed medium."
    redirect_to media_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that medium"
    redirect_to root_url
  end

end
