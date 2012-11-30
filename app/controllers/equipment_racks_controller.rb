class EquipmentRacksController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    if params[:farm_id]
      @equipment_racks = Farm.find(params[:farm_id]).equipment_racks
    elsif params[:room_id]
      @equipment_racks = EquipmentRack.find_all_by_room_id(params[:room_id])
    else
      @equipment_racks = EquipmentRack.all
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @equipment_racks }
      format.xml  { render :xml => @equipment_racks }
      format.js   { render :partial => "select_options", :object => @equipment_racks }
    end
  end
  
  def show
  end
  
  def diagram
    respond_to do |format|
      format.html
      format.js   { render :partial => "elevation_diagram", :locals => { :rack => @equipment_rack }}
      format.xml  { render :xml => @rack }
      format.json { render :json => @rack }
    end
  end
  
  def new
  end
  
  def create
    if @equipment_rack.save
      flash[:notice] = "Successfully created equipment rack."
      redirect_to @equipment_rack
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @equipment_rack.update_attributes(params[:equipment_rack])
      flash[:notice] = "Successfully updated equipment rack."
      redirect_to @equipment_rack
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @equipment_rack.destroy
    flash[:notice] = "Successfully destroyed equipment rack."
    redirect_to equipment_racks_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that equipment rack"
    redirect_to root_url
  end

end
