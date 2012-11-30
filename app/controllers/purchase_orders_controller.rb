class PurchaseOrdersController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @purchase_orders = PurchaseOrder.all
  end
  
  def show
  end
  
  def new
  end
  
  def download
    path = @purchase_order.attachment.path('original')
    head(:bad_request) and return unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

    send_file_options = {
      :type => @purchase_order.attachment.content_type,
      :filename => @purchase_order.attachment.original_filename
    }

    case SEND_FILE_METHOD
      when :apache then send_file_options[:x_sendfile] = true
      when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    end

    send_file(path, send_file_options)
  end
  
  def create
    if @purchase_order.save
      flash[:notice] = "Successfully created purchase order."
      redirect_to @purchase_order
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @purchase_order.update_attributes(params[:purchase_order])
      flash[:notice] = "Successfully updated purchase order."
      redirect_to @purchase_order
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @purchase_order.destroy
    flash[:notice] = "Successfully destroyed purchase order."
    redirect_to purchase_orders_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that purchase order"
    redirect_to root_url
  end
end
