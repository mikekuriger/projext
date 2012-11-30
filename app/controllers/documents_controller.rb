class DocumentsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def show
    send_file @document.data.path, :type => @document.content_type
  end
  
  def download
    logger.debug("@document = #{@document.inspect}")
    send_file @document.data.path, :type => @document.content_type, :disposition => 'attachment', :x_sendfile => true
  end
  
  def destroy
    respond_to do |format|
      if @document.destroy
        format.html {
          flash[:notice] = "Successfully destroyed document."
          redirect_to documents_url
        }
        format.js
      else
        format.html {
          flash[:error] = "Failed to destroy document."
          redirect_to @document
        }
        format.js { head :bad_request and return }
      end
    end
  end
end
