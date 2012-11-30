class ApplicationController < ActionController::Base
  # EJD - 2010/04/22 - switched to Hoptoad
  # include ExceptionNotifiable

  # layout "transdmin"
  layout "oldwham"

  before_filter :set_show_inactive
  
  ## Begin Clearance authentication
  include Clearance::Authentication
  
  # Need to override the current_user method
  # Original:
  # # User in the current cookie
  # #
  # # @return [User, nil]
  # def current_user
  #   @_current_user ||= user_from_cookie
  # end
  def current_user
    @_current_user ||= (user_from_cookie || user_from_headers || user_from_api_key)
  end
  ## End Clearance authentication

  helper :all

  protect_from_forgery

  # For crumble (http://github.com/mattmatt/crumble)
  helper :breadcrumbs

  # Pretty error messages (http://www.perfectline.co.uk/blog/custom-dynamic-error-pages-in-ruby-on-rails)
  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    # rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end
  
  # For CanCan authorization
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {
        flash[:error] = exception.message
        if signed_in?
          redirect_to root_url
        else
          redirect_to sign_in_url
        end
      }
      format.xml { head :forbidden }
      format.json { head :forbidden }
    end
  end
  
  # For iconoclast view helpers
  helper Iconoclast::IconHelper
  
  # Common CSV export function (for excel)
  def export_csv(objects, fn)
    filename = I18n.l(Time.now, :format => :short) + "-#{fn}"
    content = objects.to_csv
    send_data content,
              :type => "text/csv; charset=utf-8; header=present",
              :disposition => "attachment; filename=#{filename}"
  end
  
  def set_show_inactive
    session[:show_inactive] = true if params[:show_inactive]
    session[:show_inactive] = false if params[:hide_inactive]
    session[:show_inactive]
  end
  
  protected
    ## Begin Clearance authentication protected methods
    def user_from_api_key
      unless (params[:api_key].nil? || params[:email].nil?)
        if (user = User.find_by_email(params[:email]) unless params[:email].empty?)
          return user if (user.api_is_enabled? && user.api_key == params[:api_key])
        end
      end
    end
    
    # API auth data can be included in HTTP headers as well
    def user_from_headers
      if request.headers['X-WHAM-Username'] && request.headers['X-WHAM-API-Key']
        if (user = User.find_by_email(request.headers['X-WHAM-Username']))
          return user if (user.api_is_enabled? && user.api_key == request.headers['X-WHAM-API-Key'])
        end
      end
    end
    ## End Clearance authentication protected methods
    
    # For exception notifier
    # exception_data :additional_data
    # 
    # def additional_data
    #   { :current_user => @current_user }
    # end
    
  private
    def render_not_found(exception)
      log_error(exception)
      render :template => "/error/404.html.erb", :layout => "error", :status => 404
    end

    def render_error(exception)
      log_error(exception)
      notify_hoptoad(exception)
      render :template => "/error/500.html.erb", :layout => "error", :status => 500
    end
end
