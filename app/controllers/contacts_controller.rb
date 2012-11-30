class ContactsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @contacts = Contact.all
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @contact.save
      flash[:notice] = "Successfully created contact."
      redirect_to @contact
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Successfully updated contact."
      redirect_to @contact
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @contact.destroy
    flash[:notice] = "Successfully destroyed contact."
    redirect_to contacts_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that contact"
    redirect_to root_url
  end
end
