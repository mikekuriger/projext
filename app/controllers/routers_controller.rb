class RoutersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @routers = Router.all
  end
  
  def show
    @router = Router.find(params[:id])
  end
  
  def new
    @router = Router.new
  end
  
  def create
    @router = Router.new(params[:router])
    if @router.save
      flash[:notice] = "Successfully created router."
      redirect_to @router
    else
      render :action => 'new'
    end
  end
  
  def edit
    @router = Router.find(params[:id])
  end
  
  def update
    @router = Router.find(params[:id])
    if @router.update_attributes(params[:router])
      flash[:notice] = "Successfully updated router."
      redirect_to @router
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @router = Router.find(params[:id])
    @router.destroy
    flash[:notice] = "Successfully destroyed router."
    redirect_to routers_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that router"
    redirect_to root_url
  end
end
