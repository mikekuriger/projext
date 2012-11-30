class FirewallsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @firewalls = Firewall.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @firewall.save
      flash[:notice] = "Successfully created firewall."
      redirect_to @firewall
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @firewall.update_attributes(params[:firewall])
      flash[:notice] = "Successfully updated firewall."
      redirect_to @firewall
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @firewall.destroy
    flash[:notice] = "Successfully destroyed firewall."
    redirect_to firewalls_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that firewall"
    redirect_to root_url
  end
end
