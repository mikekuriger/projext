class StorageShelvesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @storage_shelves = StorageShelf.all
  end
  
  def show
    @storage_shelf = StorageShelf.find(params[:id])
  end
  
  def new
    @storage_shelf = StorageShelf.new
  end
  
  def create
    @storage_shelf = StorageShelf.new(params[:storage_shelf])
    if @storage_shelf.save
      flash[:notice] = "Successfully created storage shelf."
      redirect_to @storage_shelf
    else
      render :action => 'new'
    end
  end
  
  def edit
    @storage_shelf = StorageShelf.find(params[:id])
  end
  
  def update
    @storage_shelf = StorageShelf.find(params[:id])
    if @storage_shelf.update_attributes(params[:storage_shelf])
      flash[:notice] = "Successfully updated storage shelf."
      redirect_to @storage_shelf
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @storage_shelf = StorageShelf.find(params[:id])
    @storage_shelf.destroy
    flash[:notice] = "Successfully destroyed storage shelf."
    redirect_to storage_shelves_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that storage shelf"
    redirect_to root_url
  end
end
