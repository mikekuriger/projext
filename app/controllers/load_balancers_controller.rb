class LoadBalancersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @load_balancers = LoadBalancer.all
  end
  
  def show
    @load_balancer = LoadBalancer.find(params[:id])
  end
  
  def new
    @load_balancer = LoadBalancer.new
  end
  
  def create
    @load_balancer = LoadBalancer.new(params[:load_balancer])
    if @load_balancer.save
      flash[:notice] = "Successfully created load balancer."
      redirect_to @load_balancer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @load_balancer = LoadBalancer.find(params[:id])
  end
  
  def update
    @load_balancer = LoadBalancer.find(params[:id])
    if @load_balancer.update_attributes(params[:load_balancer])
      flash[:notice] = "Successfully updated load balancer."
      redirect_to @load_balancer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @load_balancer = LoadBalancer.find(params[:id])
    @load_balancer.destroy
    flash[:notice] = "Successfully destroyed load balancer."
    redirect_to load_balancers_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that load_balancer"
    redirect_to root_url
  end
end
