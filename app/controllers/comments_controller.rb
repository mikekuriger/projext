class CommentsController < ApplicationController
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_request

  def index
  end
  
  def show
  end
  
  def new
  end
  
  def create
    eval_str = "#{params[:model]}.find(params[:#{params[:model].downcase}_id])"
    @parent = eval(eval_str)
    @comment = @parent.comments.build(params[:comment])
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html {
          flash[:notice] = "Successfully added comment."
          redirect_to @parent
        }
        format.js   { render :partial => @comment }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.json { render :json => @comment }
      else
        format.html { render :action => 'new' }
        format.js   { render @comment.errors, :status => 500 }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_url
  end

  private
  def invalid_request
    flash[:error] = "Couldn't find that comment"
    redirect_to root_url
  end
end
