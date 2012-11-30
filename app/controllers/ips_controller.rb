class IpsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @ips = Ip.all
  end
  
  def autocomplete
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @ip.save
      flash[:notice] = "Successfully created ip."
      redirect_to @ip
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @ip.update_attributes(params[:ip])
      flash[:notice] = "Successfully updated ip."
      redirect_to @ip
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @ip.destroy
    flash[:notice] = "Successfully destroyed ip."
    redirect_to ips_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that IP"
    redirect_to root_url
  end
  
end
