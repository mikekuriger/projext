class AssetsController < ApplicationController
  before_filter :unset_attributes

  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request
  
  def index
#    @assets = Asset.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))
    @assets = Asset.paginate(
      :page => params[:page],
      :per_page => assets_per_page,
      # :group_by => 'first_letter',
      :order => 'name ASC'
    )
    # @assets.add_missing_links(('A'..'z').to_a)
    respond_to do |format|
      format.html
      format.js
      format.csv
      format.xml { render :xml => @assets }
    end
  end
  
  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @asset }
      format.puppet
    end
  end
  
  def tooltip
  end
  
  def new
  end
  
  def create
    if @asset.save
      flash[:notice] = "Successfully created asset."
      redirect_to @asset
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @asset.update_attributes(params[:asset])
      flash[:notice] = "Successfully updated asset."
      redirect_to @asset
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @asset.destroy
    flash[:notice] = "Successfully destroyed asset."
    redirect_to assets_url
  end
  
  private
    def invalid_request
      flash[:error] = "Couldn't find that asset"
      redirect_to root_url
    end  
    
    def unset_attributes    # Unset the special attributes used to allow formtastic cascading selects
      params.delete 'hardware_manufacturer'
    end
    
    def assets_per_page 
      if params[:per_page] 
        session[:assets_per_page] = params[:per_page] 
      end 
      session[:assets_per_page]
    end
end
