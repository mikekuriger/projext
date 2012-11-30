class VendorsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 10
  
  def index
    @vendors = Vendor.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))
    # @vendors = Vendor.all
    
    respond_to do |format|
      format.html
      format.csv { export_csv(@vendors, 'vendors.csv') }
      format.xls { send_data @vendors.to_xls }
      format.xml { render :xml => @vendors }
      format.json { render :json => @vendors }
      format.yaml { send_data @vendors.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @vendor.save
      flash[:notice] = "Successfully created vendor."
      redirect_to @vendor
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @vendor.update_attributes(params[:vendor])
      flash[:notice] = "Successfully updated vendor."
      redirect_to @vendor
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @vendor.destroy
    flash[:notice] = "Successfully destroyed vendor."
    redirect_to vendors_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that vendor"
    redirect_to root_url
  end
  
end
