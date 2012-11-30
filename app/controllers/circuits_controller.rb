class CircuitsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @circuits = Circuit.all
  end
  
  def show
    @circuit = Circuit.find(params[:id])
  end
  
  def new
    @circuit = Circuit.new
  end
  
  def create
    @circuit = Circuit.new(params[:circuit])
    if @circuit.save
      flash[:notice] = "Successfully created circuit."
      redirect_to @circuit
    else
      render :action => 'new'
    end
  end
  
  def edit
    @circuit = Circuit.find(params[:id])
  end
  
  def update
    @circuit = Circuit.find(params[:id])
    if @circuit.update_attributes(params[:circuit])
      flash[:notice] = "Successfully updated circuit."
      redirect_to @circuit
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @circuit = Circuit.find(params[:id])
    @circuit.destroy
    flash[:notice] = "Successfully destroyed circuit."
    redirect_to circuits_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that circuit"
    redirect_to root_url
  end
end
