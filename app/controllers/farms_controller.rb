class FarmsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  # For pagination
  PER_PAGE = 30

  def index
    conditions = [ "state = 'active'" ] unless params[:show_inactive]
    includes = [ :assets ]
    xml_includes = { :assets => {:only => [:id, :hostname, :domain, :uuid]} }
    json_includes = xml_includes
    
    @farms = Farm.paginate :per_page => (params[:per_page] || PER_PAGE),
                           :page => params[:page],
                           :order => 'name ASC',
                           # :include => includes,
                           :conditions => conditions
    
    # If the user is an app admin, then he should be able to create new customers at this screen as well
    @farm = Farm.new if can? :create, Farm
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@farms, 'farms.csv') }
      format.xls  { send_data @farms.to_xls }
      format.xml  { render :xml => @farms.to_xml(:include => xml_includes) }
      format.json { render :json => @farms.to_json(:include => json_includes) }
      format.yaml { send_data @farms.to_yaml }
    end
  end
  
  def show
    includes = [ :assets, :servers, :virtual_servers, :switches, :storage_arrays ]
    xml_includes = includes
    json_includes = xml_includes
    
    @farm = Farm.find(params[:id], :include => includes)
    respond_to do |format|
      format.html
      format.js
      format.csv  { @filename = "farm_#{@farm.name.gsub(' ', '_')}_#{Time.now.strftime('%Y-%m-%d_%H:%M:%S')}.csv" }
      format.xls  { send_data @farm.to_xls }
      format.xml  { render :xml => @farm.to_xml(:include => xml_includes) }
      format.json { render :json => @farm.to_json(:include => json_includes) }
      format.yaml { send_data @farm.to_yaml }
    end
  end
  
  def diagram
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @farm.save
        format.html {
          flash[:notice] = 'Successfully created farm.'
          redirect_to @farm
        }
        format.js   { render :partial => @farm }
        format.xml  { render :xml => @farm, :status => :created, :location => @farm }
      else
        format.html { render :action => "new" }
        format.js   { render @farm.errors, :status => 500 }
        format.xml  { render :xml => @farm.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @farm.update_attributes(params[:farm])
        format.html {
          flash[:notice] = "Successfully updated farm."
          redirect_to @farm
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @farm.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @farm.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "Successfully destroyed farm."
        redirect_to(farms_url)
      }
      format.xml  { head :ok }
    end
  end
  
  # def activate
  #   @farm.activate
  #   flash[:notice] = "Successfully activated farm."
  #   redirect_to @farm
  # end
  # 
  # def deactivate
  #   @farm.deactivate
  #   flash[:notice] = "Successfully deactivated farm."
  #   redirect_to @farm
  # end
    
  private
  def invalid_request
    respond_to do |format|
      format.html {
        flash[:error] = "Couldn't find that farm"
        redirect_to root_url
      }
#      format.xml
    end
  end
end
