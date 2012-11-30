class SwitchModulesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @switch_modules = SwitchModule.all
  end
  
  def show
    @switch_module = SwitchModule.find(params[:id])
  end
  
  def new
    @switch_module = SwitchModule.new
  end
  
  def create
    @switch_module = SwitchModule.new(params[:switch_module])
    if @switch_module.save
      flash[:notice] = "Successfully created switch module."
      redirect_to @switch_module
    else
      render :action => 'new'
    end
  end
  
  def edit
    @switch_module = SwitchModule.find(params[:id])
  end
  
  def update
    @switch_module = SwitchModule.find(params[:id])
    if @switch_module.update_attributes(params[:switch_module])
      flash[:notice] = "Successfully updated switch module."
      redirect_to @switch_module
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @switch_module = SwitchModule.find(params[:id])
    @switch_module.destroy
    flash[:notice] = "Successfully destroyed switch module."
    redirect_to switch_modules_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that switch_module"
    redirect_to root_url
  end
end
