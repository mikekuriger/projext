class CustomersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @customers = Customer.all
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @customers.to_xml }
      format.csv { export_csv(@customers, 'customers.csv') }
      format.xls { send_data @customers.to_xls }
      format.json { render :json => @customers }
      format.yaml { send_data @customers.to_yaml }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @customer.save
      flash[:notice] = "Successfully created customer."
      redirect_to @customer
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @customer.update_attributes(params[:customer])
      flash[:notice] = "Successfully updated customer."
      redirect_to @customer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @customer.destroy
    flash[:notice] = "Successfully destroyed customer."
    redirect_to customers_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that customer"
    redirect_to root_url
  end
end
