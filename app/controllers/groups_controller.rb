class GroupsController < ApplicationController
  ###
  # For CanCan
  load_and_authorize_resource
  ###

  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request
  
  PER_PAGE = 30
  
  def index
    @groups = Group.paginate(
                               :page => params[:page],
                               :per_page => (params[:per_page] || PER_PAGE)
                            )
    
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@groups, "groups.csv") }
      format.xls  { send_data @groups.to_xls }
      format.xml  { render :xml => @groups.to_xml }
      format.json { render :json => @groups.to_json }
      format.yaml { send_data @groups.to_yaml }
    end
  end
  
  def autocomplete
    @groups = Group.all(:conditions => ['name LIKE ?', "%#{params[:search]}%"])
  end
  
  def show
    includes = [ :assets ]
    xml_includes = { :assets => {:only => [:id, :hostname, :domain, :uuid]} }
    json_includes = includes
    
    @group = Group.find(params[:id], :include => includes)
    
    respond_to do |format|
      format.html
      format.js
      format.csv  { @filename = "group_#{@group.name.gsub(' ', '_')}_#{Time.now.strftime('%Y-%m-%d_%H:%M:%S')}.csv" }
      format.xls  { send_data @group.to_xls }
      format.xml  { render :xml => @group.to_xml(:include => xml_includes) }
      format.json { render :json => @group.to_json(:include => json_includes) }
      format.yaml { send_data @group.to_yaml }
    end
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @group.save
        format.html {
          flash[:notice] = "Successfully created group."
          redirect_to @group
        }
        format.js   { render :partial => @group }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.js   { render @group.errors, :status => 500 }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to @group
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @group.destroy
    flash[:notice] = "Successfully destroyed group."
    redirect_to groups_url
  end
  
  def activate
    respond_to do |format|
      if @group.activate
        format.html {
          flash[:notice] = "Activated group."
          redirect_to groups_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@group, 'row'), :partial => "group", :object => @group
          end
        }
        format.xml  { render :xml => @group }
      else
        format.html { render :action => "edit" }
        format.js   { render @group.errors, :status => 500 }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def deactivate
    respond_to do |format|
      if @group.deactivate
        format.html {
          flash[:notice] = "Deactivated group."
          redirect_to groups_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@group, 'row'), :partial => "group", :object => @group
          end
        }
        format.xml  { render :xml => @group }
      else
        format.html { render :action => "edit" }
        format.js   { render @group.errors, :status => 500 }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    def invalid_request
      flash[:error] = "Couldn't find that group"
      redirect_to root_url
    end
end
