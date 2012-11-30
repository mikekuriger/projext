class OperatingsystemsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30
  
  def index
    @operatingsystems = Operatingsystem.paginate :per_page => (params[:per_page] || PER_PAGE), :page => params[:page], :order => 'name ASC'
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@operatingsystems, 'operatingsystems.csv') }
      format.xls  { send_data @operatingsystems.to_xls }
      format.xml  { render :xml => @operatingsystems }
      format.json { render :json => @operatingsystems }
      format.yaml { send_data @operatingsystems.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @operatingsystem.save
        format.html {
          flash[:notice] = 'Successfully created operating system.'
          redirect_to @operatingsystem
        }
        format.js   { render :partial => @operatingsystem }
        format.xml  { render :xml => @operatingsystem, :status => :created, :location => @operatingsystem }
      else
        format.html { render :action => "new" }
        format.js   { render @operatingsystem.errors, :status => 500 }
        format.xml  { render :xml => @operatingsystem.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @operatingsystem.update_attributes(params[:operatingsystem])
        format.html {
          flash[:notice] = "Successfully updated operating system."
          redirect_to @operatingsystem
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operatingsystem.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @operatingsystem.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = "Successfully destroyed operating system."
        redirect_to(operatingsystems_url)
      }
      format.xml  { head :ok }
    end
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that operating system"
    redirect_to root_url
  end
end
