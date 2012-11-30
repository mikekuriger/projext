class VipsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30

  def index
    @vips = Vip.paginate :page => params[:page], :per_page => (params[:per_page] || PER_PAGE), :order => 'name ASC'
    
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@vips, 'vips.csv') }
      format.xml  { render :xml => @vips }
      format.xml  { render :xml => @vips }
      format.json { render :json => @vips }
      format.yaml { send_data @vips.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @vip.save
        format.html {
          flash[:notice] = "Successfully created vip."
          redirect_to @vip
        }
        format.js   { render :partial => @vip }
        format.xml  { render :xml => @vip, :status => :created, :location => @vip }
      else
        format.html { render :action => "new" }
        format.js   { render @vip.errors, :status => 500 }
        format.xml  { render :xml => @vip.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @vip.update_attributes(params[:vip])
      flash[:notice] = "Successfully updated vip."
      redirect_to @vip
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @vip.destroy
    flash[:notice] = "Successfully destroyed vip."
    redirect_to vips_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that vip"
    redirect_to root_url
  end

end
