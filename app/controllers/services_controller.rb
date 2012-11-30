class ServicesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30

  def index
    @services = Service.paginate(
                              :page => params[:page],
                              :per_page => (params[:per_page] || PER_PAGE),
                              :include => [ :cluster, :function ]
                            )
    
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@services, 'services.csv') }
      format.xls  { send_data @services.to_xls }
      format.xml  { render :xml => @services }
      format.json { render :json => @services }
      format.yaml { send_data @services.to_yaml }
    end
  end
  
  def search
    redirect_to(root_url) and return if ((params[:q].nil?) || (cannot? :read, Service))
    
    # EJD - 2010/04/20 - disabling for now, this is working in dev, but not in staging/prod
    # conditions = { :state => :active } unless session[:show_inactive]
    conditions = ''
    
    @query = params[:q].strip
    @services = Service.search @query,
                             :conditions => conditions,
                             :star => true,
                             :match_mode => :extended,
                             :page => params[:page],
                             :per_page => services_per_page
    
    respond_to do |format|
      format.html
      format.js
      # format.xml  { render :xml => @services.to_xml(:include => includes) }
      # format.csv { export_csv(@services, 'services.csv') }
      # format.xls { send_data @services.to_xls }
      # format.json { render :json => @services }
      # format.yaml { send_data @services.to_yaml(:include => includes) }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @service.save
        format.html {
          flash[:notice] = 'Successfully created service.'
          redirect_to @service
        }
        format.js   { render :partial => @service }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.js   { render @service.errors, :status => 500 }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @service.update_attributes(params[:service])
      flash[:notice] = "Successfully updated service."
      redirect_to @service
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @service.destroy
    flash[:notice] = "Successfully destroyed service."
    redirect_to services_url
  end
  
  private
    def invalid_request
      flash[:error] = "Couldn't find that service"
      redirect_to root_url
    end

    def services_per_page 
      if params[:per_page] 
        session[:services_per_page] = params[:per_page] 
      end 
      session[:services_per_page]
    end
end
