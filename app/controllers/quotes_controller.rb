class QuotesController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
    @quotes = Quote.all
  end
  
  def show
  end
  
  def download
    path = @quote.attachment.path('original')
    head(:bad_request) and return unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

    send_file_options = {
      :type => @quote.attachment.content_type,
      :filename => @quote.attachment.original_filename
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
    if @quote.save
      flash[:notice] = "Successfully created quote."
      redirect_to @quote
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @quote.update_attributes(params[:quote])
      flash[:notice] = "Successfully updated quote."
      redirect_to @quote
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @quote.destroy
    flash[:notice] = "Successfully destroyed quote."
    redirect_to quotes_url
  end
  
  private
  def invalid_request
    flash[:error] = "Couldn't find that quote"
    redirect_to root_url
  end
end
