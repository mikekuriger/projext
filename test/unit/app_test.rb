require 'test_helper'

class AppTest < ActiveSupport::TestCase
  should have_many :apps_clusters
  should have_many :clusters
  should have_many :sites
  
  should validate_presence_of :name
  should validate_presence_of :project_id
  
  context "A newly-created app" do
    setup do
      @app = App.new
    end
    
    should "not be valid" do
      assert !@app.valid?
    end
  end
end
