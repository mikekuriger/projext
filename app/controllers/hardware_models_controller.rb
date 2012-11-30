class HardwareModelsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30

  def index
    if params[:manufacturer_id]
      @hardware_models = HardwareModel.find_all_by_manufacturer_id(params[:manufacturer_id])
    else
      @hardware_models = HardwareModel.all
    end
    
    # @hardware_models = @t_hardware_models.paginate :per_page => (params[:per_page] || PER_PAGE), :page => params[:page], :order => 'name ASC'
    
    respond_to do |format|
      format.html
      format.js   { render :partial => "select_options", :object => @hardware_models }
      format.csv  { export_csv(@hardware_models, 'hardware_models.csv') }
      format.xls  { send_data @hardware_models.to_xls }
      format.yaml { send_data @hardware_models.to_yaml }
      format.json { render :json => @hardware_models }
      format.xml  { render :xml => @hardware_models }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @hardware_model.save
      flash[:notice] = "Successfully created hardware model."
      redirect_to @hardware_model
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @hardware_model.update_attributes(params[:hardware_model])
      flash[:notice] = "Successfully updated hardware model."
      redirect_to @hardware_model
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @hardware_model.destroy
    flash[:notice] = "Successfully destroyed hardware model."
    redirect_to hardware_models_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that hardware model"
    redirect_to root_url
  end
end
