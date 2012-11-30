class StorageArraysController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @storage_arrays = StorageArray.all
  end
  
  def show
  end
  
  def new
    @storage_array.storage_heads.build
    @storage_array.storage_shelves.build
  end
  
  def create
    if @storage_array.save
      flash[:notice] = "Successfully created storage array."
      redirect_to @storage_array
    else
      render :action => 'new'
    end
  end
  
  def edit
    # @storage_array.storage_heads.build
    # @storage_array.storage_shelves.build
  end
  
  def update
    if @storage_array.update_attributes(params[:storage_array])
      flash[:notice] = "Successfully updated storage array."
      redirect_to @storage_array
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @storage_array.destroy
    flash[:notice] = "Successfully destroyed storage array."
    redirect_to storage_arrays_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that storage array"
    redirect_to root_url
  end
end
