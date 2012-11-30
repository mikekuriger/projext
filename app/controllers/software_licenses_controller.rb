class SoftwareLicensesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @software_licenses = SoftwareLicense.all
  end
  
  def show
    @software_license = SoftwareLicense.find(params[:id])
  end
  
  def new
    @software_license = SoftwareLicense.new
  end
  
  def create
    @software_license = SoftwareLicense.new(params[:software_license])
    if @software_license.save
      flash[:notice] = "Successfully created software license."
      redirect_to @software_license
    else
      render :action => 'new'
    end
  end
  
  def edit
    @software_license = SoftwareLicense.find(params[:id])
  end
  
  def update
    @software_license = SoftwareLicense.find(params[:id])
    if @software_license.update_attributes(params[:software_license])
      flash[:notice] = "Successfully updated software license."
      redirect_to @software_license
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @software_license = SoftwareLicense.find(params[:id])
    @software_license.destroy
    flash[:notice] = "Successfully destroyed software license."
    redirect_to software_licenses_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that software license"
    redirect_to root_url
  end
end
