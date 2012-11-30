class InterfacesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    if params[:asset_id]
      @interfaces = Interface.find_all_by_asset_id(params[:asset_id])
    else
      @interfaces = Interface.all
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @interfaces }
      format.xml  { render :xml => @interfaces }
      format.js   { render :partial => "select_options", :object => @interfaces }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @interface.save
      flash[:notice] = "Successfully created interface."
      redirect_to @interface
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @interface.update_attributes(params[:interface])
      flash[:notice] = "Successfully updated interface."
      redirect_to @interface
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @interface.destroy
    flash[:notice] = "Successfully destroyed interface."
    redirect_to interfaces_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that interface"
    redirect_to root_url
  end
end
