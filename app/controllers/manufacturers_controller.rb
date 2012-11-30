class ManufacturersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30
  
  def index
    @manufacturers = Manufacturer.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))
    respond_to do |format|
      format.html
      format.js
      format.csv { export_csv(@manufacturers, 'manufacturers.csv') }
      format.xls { send_data @manufacturers.to_xls }
      format.xml { render :xml => @manufacturers }
      format.json { render :json => @manufacturers }
      format.yaml { send_data @manufacturers.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @manufacturer.save
        format.html {
          flash[:notice] = 'Successfully created operating system.'
          redirect_to @manufacturer
        }
        format.js   { render :partial => @manufacturer }
        format.xml  { render :xml => @manufacturer, :status => :created, :location => @manufacturer }
      else
        format.html { render :action => "new" }
        format.js   { render @manufacturer.errors, :status => 500 }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @manufacturer.update_attributes(params[:manufacturer])
        format.html {
          flash[:notice] = "Successfully updated operating system."
          redirect_to @manufacturer
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @manufacturer.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "Successfully destroyed manufacturer."
        redirect_to(manufacturers_url)
      }
      format.xml  { head :ok }
    end
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that manufacturer"
    redirect_to root_url
  end

end
