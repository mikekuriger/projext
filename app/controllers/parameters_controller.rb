class ParametersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  PER_PAGE = 30
  def index
    @parameters = Parameter.paginate(:page => params[:page], :per_page => PER_PAGE)
  
    respond_to do |format|
      format.html
      format.js
      format.csv  { export_csv(@parameters, 'parameters.csv') }
      format.xls  { send_data @parameters.to_xls }
      format.xml  { render :xml => @parameters }
      format.json { render :json => @parameters }
      format.yaml { send_data @parameters.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @parameter.save
      flash[:notice] = "Successfully created parameter."
      redirect_to @parameter
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @parameter.update_attributes(params[:parameter])
      flash[:notice] = "Successfully updated parameter."
      redirect_to @parameter
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @parameter.destroy
    flash[:notice] = "Successfully destroyed parameter."
    redirect_to parameters_url
  end

  def activate
    respond_to do |format|
      if @parameter.activate
        format.html {
          flash[:notice] = "Activated parameter."
          redirect_to parameters_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@parameter, 'row'), :partial => "parameter", :object => @parameter
          end
        }
        format.xml  { render :xml => @parameter }
      else
        format.html { render :action => "edit" }
        format.js   { render @parameter.errors, :status => 500 }
        format.xml  { render :xml => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def deactivate
    respond_to do |format|
      if @parameter.deactivate
        format.html {
          flash[:notice] = "Deactivated parameter."
          redirect_to parameters_url
        }
        format.js   {
          render(:update) do |page|
            page.replace dom_id(@parameter, 'row'), :partial => "parameter", :object => @parameter
          end
        }
        format.xml  { render :xml => @parameter }
      else
        format.html { render :action => "edit" }
        format.js   { render @parameter.errors, :status => 500 }
        format.xml  { render :xml => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def invalid_request
      flash[:error] = "Couldn't find that parameter"
      redirect_to root_url
    end
end
