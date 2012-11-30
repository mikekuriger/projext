class RoomsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    if params[:building_id]
      @rooms = Room.find_all_by_building_id(params[:building_id])
    else
      @rooms = Room.all
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @rooms }
      format.xml  { render :xml => @rooms }
      format.js   { render :partial => "select_options", :object => @rooms }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if @room.save
      flash[:notice] = "Successfully created room."
      redirect_to @room
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @room.update_attributes(params[:room])
      flash[:notice] = "Successfully updated room."
      redirect_to @room
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @room.destroy
    flash[:notice] = "Successfully destroyed room."
    redirect_to rooms_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that room"
    redirect_to root_url
  end
  
end
