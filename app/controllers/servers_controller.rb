class ServersController < ApplicationController
  # We want agents to be able to register and update servers directly
  # TODO: need to fix this so agents automatically get an auth token first
  skip_before_filter :verify_authenticity_token, :only => [ :create, :update, :ping ]
  before_filter :find_server_or_virtual_server, :only => [ :show, :ping, :update ]
  
  load_and_authorize_resource :nested => :agent
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    # Show only active servers by default
    conditions = { :state => Asset::ACTIVE_STATES.collect{|state| state.to_s} } unless session[:show_inactive]
    includes = [ :group,
                 :interfaces,
                 { :services => [:cluster, :function] },
                 { :operatingsystem => [:manufacturer] }
               ]
    json_includes = includes
    
    xml_includes = { :group => {},
                     :interfaces => {},
                     :operatingsystem => {
                       :include => {
                         :manufacturer => {}
                       }
                     },
                     :services => {
                       :include => {
                         :cluster => {},
                         :function => {}
                       }
                     }
                   }
    yaml_includes = includes
    order ||= params[:order]  # TODO: sanitize this

    # TODO: sanitize all params
    Server
    VirtualServer
    if params[:group_id]
      @servers_nonpaginated = 
        # Rails.cache.fetch({:group_id => params[:group_id], :conditions => conditions, :order => order}.to_s, :expires_in => 1.hour) {
          # Asset.find_all_by_type_and_group_id(['Server', 'VirtualServer'],
          Server.find_all_by_group_id( params[:group_id],
                                       :conditions => conditions,
                                       :include => includes,
                                       :order => order)
        # }
    elsif params[:farm_id]
      # @servers_nonpaginated = Asset.find_all_by_type_and_farm_id(['Server', 'VirtualServer'],
      @servers_nonpaginated = Server.find_all_by_farm_id( params[:farm_id],
                                                          :conditions => conditions,
                                                          :include => includes,
                                                          :order => order )
    elsif params[:cluster_id]
      @cluster = Cluster.find(params[:cluster_id])
      @servers_nonpaginated = @cluster.assets.find_all_by_type(['Server', 'VirtualServer'],
                                                                  :conditions => conditions,
                                                                  :include => includes,
                                                                  :order => order)
    elsif params[:function_id]
      @function = Function.find(params[:function_id])
      @servers_nonpaginated = @function.assets.find_all_by_type(['Server', 'VirtualServer'],
                                                                  :conditions => conditions,
                                                                  :include => includes,
                                                                  :order => order)
    else
      if params[:format] == 'yaml'
        @servers_nonpaginated = Rails.cache.fetch({:conditions => conditions, :order => order}.to_s, :expires_in => 1.hour) {
          # Asset.find_all_by_type(['Server', 'VirtualServer'],
          Server.all( :conditions => conditions,
                      :include => includes,
                      :order => order )
        }
      else
        @servers_nonpaginated = 
          # Asset.find_all_by_type(['Server', 'VirtualServer'],
          Server.all( :conditions => conditions,
                      :include => includes,
                      :order => order )
      end
    end
  
    unless params[:format] == 'yaml'
      @servers = @servers_nonpaginated.paginate(:page => params[:page], :per_page => servers_per_page)
    end
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @servers_nonpaginated.to_xml(:include => xml_includes) }
      # format.csv { export_csv(@servers_nonpaginated, 'servers.csv') }
      format.csv
      format.xls { send_data @servers_nonpaginated.to_xls }
      format.json { render :json => @servers_nonpaginated.to_json(:include => json_includes) }
      format.yaml { send_data @servers_nonpaginated.to_yaml }
    end
  end
  
  def autocomplete
    @servers = Server.all(:conditions => ['name LIKE ?', "%#{params[:search]}%"])
  end
  
  def search
    redirect_to(root_url) and return if ((params[:q].nil?) || (cannot? :read, Server))
    
    # EJD - 2010/04/20 - disabling for now, this is working in dev, but not in staging/prod
    # conditions = { :state => Asset::ACTIVE_STATES.collect{|state| state.to_s} } unless session[:show_inactive]
    conditions = ''
    includes = [ :group,
                 :interfaces,
                 { :services => [:cluster, :function] },
                 { :operatingsystem => [:manufacturer] }
               ]
    json_includes = includes
    
    xml_includes = { :group => {},
                     :interfaces => {},
                     :operatingsystem => {
                       :include => {
                         :manufacturer => {}
                       }
                     },
                     :services => {
                       :include => {
                         :cluster => {},
                         :function => {}
                       }
                     }
                   }
    yaml_includes = includes
    
    @query = params[:q].strip
    @servers = Server.search @query,
                             :conditions => conditions,
                             :star => true,
                             :match_mode => :extended,
                             :include => includes,        # This is necessary for YAML output
                             :page => params[:page],
                             :per_page => servers_per_page
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @servers.to_xml(:include => xml_includes) }
      # format.xml  { render :xml => @servers.to_xml }
      format.csv { export_csv(@servers, "servers_search_#{@query}_#{Time.now.strftime('%Y-%m-%d_%H:%M:%S')}.csv") }
      format.xls { send_data @servers.to_xls }
      format.json { render :json => @servers.to_json(:include => json_includes) }
      format.yaml { send_data @servers.to_yaml }
    end
  end
  
  def show
    # TODO: for some reason, access is denied when using /agents/<id>/server to view a server. Need to figure out why.
    # 2010/02/28: Figured out why, it was cancan. Need to test with the :nested option
    @server = Agent.find(params[:agent_id]).server if (@server.nil? && params[:agent_id])
    @server = VirtualServer.find(params[:id]) if @server.nil?
    respond_to do |format|
      format.html
      # format.xml { render :xml => @server.to_xml(:include => [ :interfaces, :services ]) }
      format.xml { render :xml => @server }
      format.puppet
    end
  end
  
  # For WHAMD to periodically ping
  def ping
    respond_to do |format|
      if @server.ping
        format.xml  { render :xml => @server.to_xml(:only => [ :id, :name, :hostname, :last_seen ]) }
        # format.xml  { head :ok, :location => server_path(@server) }
      else
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def new
    @server.interfaces.build
    @server.services.build
  end
  
  # Create a server
  # Will also be posted to by WHAMD to register a new server
  def create
    @server[:name] ||= @server[:hostname]
    @server.build_agent(params[:agent]) if params[:agent]
    
    respond_to do |format|
      if @server.save
        format.html {
          flash[:notice] = "Successfully created server."
          redirect_to @server
        }
        format.js   { render :partial => @server }
        format.xml  { render :xml => @server.to_xml(:only => [ :id, :name, :hostname ]) }
      else
        format.html { render :action => 'new' }
        format.js   { render @server.errors, :status => 500 }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    params[:server].delete(:id)   # EJD - hack because activeresource is dumb and insists on passing ID
    params[:server].delete(:created_at)
    params[:server].delete(:updated_at)
    params[:server].delete(:interfaces_attributes) if params[:server][:interfaces_attributes].nil?
    # if params[:server].key?(:services)
    #   params[:server][:services].map! {|s| s.delete(:id); s.delete(:created_at); s.delete(:updated_at)}
    #   @server.services.build(params[:server][:services])
    # # if params[:server].key? :services
    # #   params[:server][:services].each do |service|
    # #     service.delete(:id)
    # #     service.delete(:created_at)
    # #     service.delete(:updated_at)
    # #     @server.services.build(service)
    # #   end
    # #   params[:server].delete(:services)
    # end
    @server.build_agent(params[:agent]) if params[:agent]
    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html {
          flash[:notice] = "Successfully updated server."
          redirect_to @server
        }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { logger.debug("@server.errors = #{@server.errors.inspect}"); render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @server.destroy
    flash[:notice] = "Successfully destroyed server."
    redirect_to servers_url
  end

  private
  def invalid_request
    respond_to do |format|
      format.html {
        flash[:error] = "Couldn't find that server"
        redirect_to root_url
      }
      format.xml { head :not_found }
      format.json { head :not_found }
    end
  end
  
  def servers_per_page 
    if params[:per_page] 
      session[:servers_per_page] = params[:per_page] 
    end 
    session[:servers_per_page]
  end
  
  def find_server_or_virtual_server
    begin
      @server = Server.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @server = VirtualServer.find(params[:id])
    end
  end
end
