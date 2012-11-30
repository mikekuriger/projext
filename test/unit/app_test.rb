require 'test_helper'

class AppTest < ActiveSupport::TestCase
  should_have_many :apps_clusters
  should_have_many :clusters
  should_have_many :sites
  
  should_validate_presence_of :name, :message => "Name cannot be blank"
  should_validate_presence_of :project_id, :message => "Project cannot be blank"
  
  context "A newly-created app" do
    setup do
      @app = App.new
    end
    
    should "not be valid" do
      assert !@app.valid?
    end
  end
end
