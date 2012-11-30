class BuildingsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request
  
  def index
    @buildings = Building.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @building.save
      flash[:notice] = "Successfully created building."
      redirect_to @building
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @building.update_attributes(params[:building])
      flash[:notice] = "Successfully updated building."
      redirect_to @building
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @building.destroy
    flash[:notice] = "Successfully destroyed building."
    redirect_to buildings_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that building"
    redirect_to root_url
  end
  
end
