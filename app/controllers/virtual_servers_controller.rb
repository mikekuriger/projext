class VirtualServersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [ :create, :update, :ping ]

  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    # Show only active servers by default
    conditions = { :state => Asset::ACTIVE_STATES.collect{|state| state.to_s} } unless session[:show_inactive]
    
    if params[:group_id]
      @virtual_servers = VirtualServer.find_all_by_group_id(params[:group_id], :conditions => conditions)
    elsif params[:farm_id]
      @virtual_servers = VirtualServer.find_all_by_farm_id(params[:farm_id], :conditions => conditions)
    elsif params[:cluster_id]
      @cluster = Cluster.find(params[:cluster_id])
      @virtual_servers = @cluster.assets.find_all_by_type('VirtualServer', :conditions => conditions)
    elsif params[:function_id]
      @function = Function.find(params[:function_id])
      @virtual_servers = @function.assets.find_all_by_type('VirtualServer', :conditions => conditions)
    else
      @virtual_servers = Asset.find_all_by_type('VirtualServer', :conditions => conditions)
    end
    
    @virtual_servers = @virtual_servers.paginate(:page => params[:page], :per_page => virtual_servers_per_page)

    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @virtual_servers.to_xml(:include => [ :interfaces, :services ]) }
      format.csv { export_csv(@virtual_servers, 'virtual_servers.csv') }
      format.xls { send_data @virtual_servers.to_xls }
      format.json { render :json => @virtual_servers }
      format.yaml { send_data @virtual_servers.to_yaml(:include => [ :interfaces, :services ]) }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @virtual_server.save
        format.html {
          flash[:notice] = "Successfully created virtual server."
          redirect_to @virtual_server
        }
        format.js   { render :partial => @virtual_server }
        format.xml  { render :xml => @virtual_server.to_xml(:only => [ :id, :name, :hostname ]) }
      else
        format.html { render :action => 'new' }
        format.js   { render @virtual_server.errors, :status => 500 }
        format.xml  { render :xml => @virtual_server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    @virtual_server.build_agent(params[:agent]) if params[:agent]
    params[:virtual_server]['parent_id'] = Server.find_by_name(params[:virtual_server]['parent_name']).id if params[:virtual_server]['parent_name']
    respond_to do |format|
      if @virtual_server.update_attributes(params[:virtual_server])
        format.html {
          flash[:notice] = "Successfully updated virtual server."
          redirect_to @virtual_server
        }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { logger.debug("@virtual_server.errors = #{@virtual_server.errors.inspect}"); render :xml => @virtual_server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @virtual_server.destroy
    flash[:notice] = "Successfully destroyed virtual server."
    redirect_to virtual_servers_url
  end

  private
  def invalid_request
    respond_to do |format|
      format.html {
        flash[:error] = "Couldn't find that virtual server"
        redirect_to root_url
      }
      format.xml { head :not_found }
      format.json { head :not_found }
    end
  end
  
  def virtual_servers_per_page 
    if params[:per_page] 
      session[:virtual_servers_per_page] = params[:per_page] 
    end 
    session[:virtual_servers_per_page]
  end
end
