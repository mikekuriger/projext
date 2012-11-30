class ContractsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  SEND_FILE_METHOD = :default
  
  def index
    @contracts = Contract.all
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @contracts.to_xml }
      format.csv { export_csv(@contracts, 'contracts.csv') }
      format.xls { send_data @contracts.to_xls }
      format.json { render :json => @contracts.to_json }
      format.yaml { send_data @contracts.to_yaml }
    end
  end
  
  def show
  end
  
  def download
    path = @contract.attachment.path('original')
    head(:bad_request) and return unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

    send_file_options = {
      :type => @contract.attachment.content_type,
      :filename => @contract.attachment.original_filename
    }

    case SEND_FILE_METHOD
      when :apache then send_file_options[:x_sendfile] = true
      when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    end

    send_file(path, send_file_options)
  end
  
  def new
  end
  
  def create
    if @contract.save
      flash[:notice] = "Successfully created contract."
      redirect_to @contract
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @contract.update_attributes(params[:contract])
      flash[:notice] = "Successfully updated contract."
      redirect_to @contract
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @contract.destroy
    flash[:notice] = "Successfully destroyed contract."
    redirect_to contracts_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that contract"
    redirect_to root_url
  end

end
