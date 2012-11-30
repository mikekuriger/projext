class AgentsController < ApplicationController
  # We want agents to be able to register themselves automatically
  # TODO: need to fix this so agents automatically get an auth token first?
  skip_before_filter :verify_authenticity_token, :only => [ :new, :create ]
  
  def new
    @agent = Agent.new

    respond_to do |format|
      format.xml  { render :xml => @agent }
    end
  end

  def create
    @agent = Agent.new(params[:agent])
    # For some reason the above isn't populating attributes properly, I'll do it manually for now
    @agent.email = params[:agent][:email] if params[:agent][:email]
    @agent.password = params[:agent][:password] if params[:agent][:password]
    
    respond_to do |format|
      if @agent.save
        @agent.enable_api!
        @agent.activate
        @agent.add_role('whamd')
        format.xml { render :text => @agent.to_xml(:only => [ :api_key, :email, :id ]) }
      else
        format.xml  { render :xml => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end
end
