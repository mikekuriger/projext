class PortsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @ports = Port.all
  end
  
  def show
    @port = Port.find(params[:id])
  end
  
  def new
    @port = Port.new
  end
  
  def create
    @port = Port.new(params[:port])
    if @port.save
      flash[:notice] = "Successfully created port."
      redirect_to @port
    else
      render :action => 'new'
    end
  end
  
  def edit
    @port = Port.find(params[:id])
  end
  
  def update
    @port = Port.find(params[:id])
    if @port.update_attributes(params[:port])
      flash[:notice] = "Successfully updated port."
      redirect_to @port
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @port = Port.find(params[:id])
    @port.destroy
    flash[:notice] = "Successfully destroyed port."
    redirect_to ports_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that port"
    redirect_to root_url
  end
end
