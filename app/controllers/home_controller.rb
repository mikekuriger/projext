class HomeController < ApplicationController
  def index
    redirect_to sign_in_path unless current_user
    @farms = Farm.active if can? :read, Farm
  end
end
