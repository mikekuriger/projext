class SearchesController < ApplicationController
  load_and_authorize_resource
  
  PER_PAGE = 30
  
  def index
    redirect_to(root_url) and return if params[:q].nil?
    
    @query = params[:q].strip
    if @query.blank?
      @results = []
      @assets = []
      @servers = []
      @switches = []
      @sites = []
      @vips = []
    else
      @results = ThinkingSphinx.search @query,
                                       :star => true,
                                       :match_mode => :extended,
                                       :page => params[:page],
                                       :per_page => (params[:per_page] || PER_PAGE)
                                       
      @assets = Asset.search @query,
                             :conditions => {:type => 'Asset'},
                             :star => true,
                             :match_mode => :extended,
                             :page => params[:page],
                             :per_page => (params[:per_page] || PER_PAGE) if can? :read, Asset
                             
      @servers = Server.search @query,
                               :star => true,
                               :match_mode => :extended,
                               :page => params[:page],
                               :per_page => (params[:per_page] || PER_PAGE) if can? :read, Server
                               
      @switches = Switch.search @query, :star => true if can? :read, Switch
      @firewalls = Firewall.search @query, :star => true if can? :read, Firewall
      @load_balancers = LoadBalancer.search @query, :star => true if can? :read, LoadBalancer
      @sites = Site.search @query, :star => true if can? :read, Site
      @vips = Vip.search @query, :star => true if can? :read, Vip
      @services = Service.search @query, :star => true if can? :read, Service
      
      # Add each service's assets to the servers array
      tassets = Array.new
      @services.each do |service|
        service.assets.each {|asset| tassets << asset if (asset.type == 'Server' || asset.type == 'VirtualServer') }
      end
      @assets_from_service_search = tassets.uniq.size
      tassets.uniq.each {|asset| @servers << asset}
      elems_before = @servers.size
      @servers.uniq!
      elems_after = @servers.size
      elems_removed = elems_before - elems_after
      @assets_from_service_search = @assets_from_service_search - elems_removed if (elems_removed && @assets_from_service_search > elems_removed)
      
    end
    
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@results, 'results.csv') }
      format.xls  { send_data @results.to_xls }
      format.xml  { render :xml => @results }
      format.json { render :json => @results }
      format.yaml { send_data @results.to_yaml }
    end
  end
end
