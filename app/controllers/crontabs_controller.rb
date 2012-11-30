class CrontabsController < ApplicationController
  load_and_authorize_resource

  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  # GET /crontabs
  # GET /crontabs.xml
  def index
    @crontabs = Crontab.all

    @crontabs_nonpaginated = Crontab.all
    @crontabs = @crontabs_nonpaginated.paginate(:page => params[:page], :per_page => crontabs_per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @crontabs }
      format.json { render :json => @crontabs_nonpaginated }
      format.yaml { send_data @crontabs_nonpaginated.to_yaml }
    end
  end

  def show
  end

  def new
  end

  # GET /crontabs/1/edit
  def edit
    @crontab = Crontab.find(params[:id])
  end

  # POST /crontabs
  # POST /crontabs.xml
  def create
    respond_to do |format|
      if @crontab.save
          format.html { flash[:notice] = 'Crontab was successfully created.'
          redirect_to(@crontab) 
          }
          format.js { render :partial => @crontab } 
          format.xml  { render :xml => @crontab, :status => :created, :location => @crontab }
      else
        format.html { render :action => "new" }
        format.js { render @crontab.errors, :status => 500 }
        format.xml  { render :xml => @crontab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /crontabs/1
  # PUT /crontabs/1.xml
  def update
    @crontab = Crontab.find(params[:id])

    respond_to do |format|
      if @crontab.update_attributes(params[:crontab])
        flash[:notice] = 'Crontab was successfully updated.'
        format.html { redirect_to(@crontab) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crontab.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /crontabs/1
  # DELETE /crontabs/1.xml
  def destroy
    @crontab.destroy
    flash[:notice] = "Successfully destroyed crontab."
    redirect_to crontabs_url
  end

  private
    def invalid_request
      flash[:error] = "Couldn't find that crontab"
      redirect_to root_url
    end
  
    def crontabs_per_page 
      if params[:per_page] 
        session[:crontabs_per_page] = params[:per_page] 
      end 
      session[:crontabs_per_page]
    end

end
