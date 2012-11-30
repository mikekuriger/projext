class DashboardsController < ApplicationController
  def show
    @newusers = User.find_all_by_state('new')
    @newagents = Agent.find_all_by_state('new')
  end
end
