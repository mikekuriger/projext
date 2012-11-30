class CpusController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @cpus = Cpu.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @cpu.save
      flash[:notice] = "Successfully created cpu."
      redirect_to @cpu
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @cpu.update_attributes(params[:cpu])
      flash[:notice] = "Successfully updated cpu."
      redirect_to @cpu
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @cpu.destroy
    flash[:notice] = "Successfully destroyed cpu."
    redirect_to cpus_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that cpu"
    redirect_to root_url
  end
end
