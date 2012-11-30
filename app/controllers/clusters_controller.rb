class ClustersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30
  
  def index
    if params[:q]
      @clusters = Cluster.find(:all, :conditions => ["first_name LIKE ? or last_name LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%"], :limit => 20)
    else
      @clusters = Cluster.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))
    end
    
    respond_to do |format|
      format.html
      format.js
      # format.js   { render :text => @clusters.map { |c| "#{c.display_name}|#{c.id}\n" }}
      format.csv  { export_csv(@clusters, 'clusters.csv') }
      format.xls  { send_data @clusters.to_xls }
      format.xml  { render :xml => @clusters }
      format.json { render :json => @clusters }
      format.yaml { send_data @clusters.to_yaml }
    end
  end
  
  def autocomplete
    @clusters = Cluster.all(:conditions => ['name LIKE ?', "%#{params[:search]}%"])
  end
  
  def show
    includes = { :services => :assets }   # Need to do it this way because of nested has_many :through associates
    xml_includes = {
                     :services => {
                       :service_assignments => {
                         :include => [:assets]
                       }
                     }
                   }
    json_includes = xml_includes
    
    @cluster = Cluster.find(params[:id], :include => includes)
    respond_to do |format|
      format.html
      format.js
      format.csv  { @filename = "cluster_#{@cluster.name.gsub(' ', '_')}_#{Time.now.strftime('%Y-%m-%d_%H:%M:%S')}.csv" }
      format.xls  { send_data @cluster.to_xls }
      format.xml  { render :xml => @cluster.to_xml(:include => xml_includes) }
      format.json { render :json => @cluster.to_json(:include => json_includes) }
      format.yaml { send_data @cluster.to_yaml }
    end
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @cluster.save
        format.html {
          flash[:notice] = 'Successfully created cluster.'
          redirect_to @cluster
        }
        format.js   { render :partial => @cluster }
        format.xml  { render :xml => @cluster, :status => :created, :location => @cluster }
      else
        format.html { render :action => "new" }
        format.js   { render @cluster.errors, :status => 500 }
        format.xml  { render :xml => @cluster.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @cluster.update_attributes(params[:cluster])
      flash[:notice] = "Successfully updated cluster."
      redirect_to @cluster
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @cluster.destroy
    flash[:notice] = "Successfully destroyed cluster."
    redirect_to clusters_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that cluster"
    redirect_to root_url
  end
end
