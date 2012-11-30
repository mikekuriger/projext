class ProjectsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    conditions = { :state => 'active' } unless session[:show_inactive]
    
    @projects_nonpaginated = Project.all(:conditions => conditions)
    @projects = @projects_nonpaginated.paginate(:page => params[:page], :per_page => projects_per_page)
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @projects_nonpaginated.to_xml }
      format.csv { export_csv(@projects_nonpaginated, 'projects.csv') }
      format.xls { send_data @projects_nonpaginated.to_xls }
      format.json { render :json => @projects_nonpaginated }
      format.yaml { send_data @projects_nonpaginated.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    logger.debug("@project = #{@project.inspect}")
    respond_to do |format|
      if @project.save
        format.html {
          flash[:notice] = "Successfully created project."
          redirect_to @project
        }
        format.js   { render :partial => @project }
        format.xml  { render :xml => @project.to_xml(:only => [ :id, :name, :hostname ]) }
      else
        format.html { render :action => 'new' }
        format.js   { head :unprocessable_entity }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html {
          flash[:notice] = "Successfully updated project."
          redirect_to @project
        }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { logger.debug("@project.errors = #{@project.errors.inspect}"); render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @project.destroy
    flash[:notice] = "Successfully destroyed project."
    redirect_to projects_url
  end

  def activate
    respond_to do |format|
      if @project.activate
        format.html {
          flash[:notice] = "Activated project."
          redirect_to projects_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@project, 'row'), :partial => "project", :object => @project
          end
        }
        format.xml  { render :xml => @project }
      else
        format.html { render :action => "edit" }
        format.js   { render @project.errors, :status => 500 }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def deactivate
    respond_to do |format|
      if @project.deactivate
        format.html {
          flash[:notice] = "Deactivated project."
          redirect_to projects_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@project, 'row'), :partial => "project", :object => @project
          end
        }
        format.xml  { render :xml => @project }
      else
        format.html { render :action => "edit" }
        format.js   { render @project.errors, :status => 500 }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def invalid_request
      flash[:error] = "Couldn't find that project"
      redirect_to root_url
    end
  
    def projects_per_page 
      if params[:per_page] 
        session[:projects_per_page] = params[:per_page] 
      end 
      session[:projects_per_page]
    end
    
end
