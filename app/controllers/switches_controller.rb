class SwitchesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30

  def index
    @switches = Switch.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))

    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@switches, 'switches.csv') }
      format.xls  { send_data @switches.to_xls }
      format.xml  { render :xml => @switches }
      format.json { render :json => @switches }
      format.yaml { send_data @switches.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    @switch[:name] ||= @switch[:hostname]
    if @switch.save
      flash[:notice] = "Successfully created switch."
      redirect_to @switch
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @switch.update_attributes(params[:switch])
      flash[:notice] = "Successfully updated switch."
      redirect_to @switch
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @switch.destroy
    flash[:notice] = "Successfully destroyed switch."
    redirect_to switches_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that switch"
    redirect_to root_url
  end
end
