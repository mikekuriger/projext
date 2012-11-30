class SitesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30
  
  def index
    @sites = Site.paginate :page => params[:page], :per_page => (params[:per_page] || PER_PAGE), :order => 'name ASC'

    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@sites, 'sites.csv') }
      format.xml  { render :xml => @sites }
      format.xml  { render :xml => @sites }
      format.json { render :json => @sites }
      format.yaml { send_data @sites.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @site.save
        format.html {
          flash[:notice] = "Successfully created site."
          redirect_to @site
        }
        format.js   { render :partial => @site }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.js   { render @site.errors, :status => 500 }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @site.update_attributes(params[:site])
      flash[:notice] = "Successfully updated site."
      redirect_to @site
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @site.destroy
    flash[:notice] = "Successfully destroyed site."
    redirect_to sites_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that site"
    redirect_to root_url
  end
  
end
