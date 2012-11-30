class FunctionsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request
  
  PER_PAGE = 30
  
  def index
    @functions = Function.paginate(:page => params[:page], :per_page => (params[:per_page] || PER_PAGE))
    
    respond_to do |format|
      format.html
      format.js
      format.csv { export_csv(@functions, 'functions.csv') }
      format.xls { send_data @functions.to_xls }
      format.xml { render :xml => @functions }
      format.json { render :json => @functions }
      format.yaml { send_data @functions.to_yaml }
    end
  end
  
  def autocomplete
    @functions = Function.all(:conditions => ['name LIKE ?', "%#{params[:search]}%"])
  end
  
  def show
  end
  
  def new
  end
  
  def create
    respond_to do |format|
      if @function.save
        format.html {
          flash[:notice] = "Successfully created function."
          redirect_to @function
        }
        format.js   { render :partial => @function }
        format.xml  { render :xml => @function, :status => :created, :location => @function }
      else
        format.html { render :action => 'new' }
        format.js   { render @function.errors, :status => 500 }
        format.xml  { render :xml => @function.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @function.update_attributes(params[:function])
      flash[:notice] = "Successfully updated function."
      redirect_to @function
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @function.destroy
    flash[:notice] = "Successfully destroyed function."
    redirect_to functions_url
  end
  
  def activate
    @function.activate
    flash[:notice] = "Activated function."
    redirect_to functions_url
  end
  
  def deactivate
    @function.deactivate
    flash[:notice] = "Deactivated function."
    redirect_to functions_url
  end
  
  private
    def invalid_request
      flash[:error] = "Couldn't find that function"
      redirect_to root_url
    end
end
