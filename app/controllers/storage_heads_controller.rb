class StorageHeadsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @storage_heads = StorageHead.all
  end
  
  def show
    @storage_head = StorageHead.find(params[:id])
  end
  
  def new
    @storage_head = StorageHead.new
  end
  
  def create
    @storage_head = StorageHead.new(params[:storage_head])
    if @storage_head.save
      flash[:notice] = "Successfully created storage head."
      redirect_to @storage_head
    else
      render :action => 'new'
    end
  end
  
  def edit
    @storage_head = StorageHead.find(params[:id])
  end
  
  def update
    @storage_head = StorageHead.find(params[:id])
    if @storage_head.update_attributes(params[:storage_head])
      flash[:notice] = "Successfully updated storage head."
      redirect_to @storage_head
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @storage_head = StorageHead.find(params[:id])
    @storage_head.destroy
    flash[:notice] = "Successfully destroyed storage head."
    redirect_to storage_heads_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that storage head"
    redirect_to root_url
  end
end
