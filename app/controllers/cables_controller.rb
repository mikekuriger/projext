class CablesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 10
  
  def index
    @cables = Cable.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))

    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@cables, 'cables.csv') }
      format.xls  { send_data @cables.to_xls }
      format.xml  { render :xml => @cables }
      format.json { render :json => @cables }
      format.yaml { send_data @cables.to_yaml }
    end
  end
  
  def show
  end
  
  def new
    @cable.build_interface
    @cable.interface.build_asset
    @cable.build_interface_target
    @cable.interface_target.build_asset
  end
  
  def create
    respond_to do |format|
      if @cable.save
        format.html {
          flash[:notice] = 'Successfully created cable.'
          redirect_to @cable
        }
        format.js   { render :partial => @cable }
        format.xml  { render :xml => @cable, :status => :created, :location => @cable }
      else
        format.html { render :action => "new" }
        format.js   { render @cable.errors, :status => :unprocessable_entity }
        format.json { render :json => @cable.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @cable.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @cable.update_attributes(params[:cable])
      flash[:notice] = "Successfully updated cable."
      redirect_to @cable
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @cable.destroy
    flash[:notice] = "Successfully destroyed cable."
    redirect_to cables_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that cable"
    redirect_to root_url
  end
end
