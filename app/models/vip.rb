class Vip < ActiveRecord::Base
  attr_accessible :name, :description, :ip, :ip_id, :notes, :state, :load_balancer_id, :port_id
  
  belongs_to :load_balancer
  belongs_to :ip
  belongs_to :port
  has_many :sites
  
  has_many :vips_assets
  has_many :assets, :through => :vips_assets
  
  validates_presence_of :name, :message => "VIP name can't be blank"
  validates_presence_of :ip_id, :message => "VIP IP can't be blank"
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  has_paper_trail
  
  # Search indexing via Thinking Sphinx
  define_index do
    indexes :name, :sortable => true
    indexes description
  
    set_property :min_infix_len => 2    # Minimum number of characters to index as an infix
    set_property :infix_fields => 'name, description'   # Only do infix indexing for specific fields
    set_property :delta => true
  end
  
  state_machine :initial => :active do
    event :deactivate do
      transition :active => :inactive
    end
    
    event :activate do
      transition :inactive => :active
    end
    
    state :active do
    end
    
    state :inactive do
    end
  end
end

# == Schema Information
#
# Table name: vips
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  ip_id       :integer(4)
#  notes       :text
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

