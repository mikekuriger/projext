class NetworkingDevicesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @networking_devices = NetworkingDevice.all
  end
  
  def show
    @networking_device = NetworkingDevice.find(params[:id])
  end
  
  def new
    @networking_device = NetworkingDevice.new
  end
  
  def create
    @networking_device = NetworkingDevice.new(params[:networking_device])
    if @networking_device.save
      flash[:notice] = "Successfully created networking device."
      redirect_to @networking_device
    else
      render :action => 'new'
    end
  end
  
  def edit
    @networking_device = NetworkingDevice.find(params[:id])
  end
  
  def update
    @networking_device = NetworkingDevice.find(params[:id])
    if @networking_device.update_attributes(params[:networking_device])
      flash[:notice] = "Successfully updated networking device."
      redirect_to @networking_device
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @networking_device = NetworkingDevice.find(params[:id])
    @networking_device.destroy
    flash[:notice] = "Successfully destroyed networking device."
    redirect_to networking_devices_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that networking_device"
    redirect_to root_url
  end
end
