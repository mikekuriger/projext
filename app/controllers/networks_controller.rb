class NetworksController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @networks = Network.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @network.save
      flash[:notice] = "Successfully created network."
      redirect_to @network
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @network.update_attributes(params[:network])
      flash[:notice] = "Successfully updated network."
      redirect_to @network
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @network.destroy
    flash[:notice] = "Successfully destroyed network."
    redirect_to networks_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that network"
    redirect_to root_url
  end
  
end
