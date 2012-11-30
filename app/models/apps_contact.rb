class AppsContact < ActiveRecord::Base
  belongs_to :app
  belongs_to :contact

  # We don't want the same contact assigned twice to a single app
  validates_uniqueness_of :contact_id, :scope => :app_id, :message => "That contact has already been assigned to this app"
  
  has_paper_trail
end
