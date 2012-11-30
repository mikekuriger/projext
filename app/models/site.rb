class Site < ActiveRecord::Base
  attr_accessible :name, :ip, :ip_id, :vip, :vip_id, :cluster, :cluster_id, :customer, :customer_id, :state
  
  belongs_to :ip
  has_one :network, :through => :ip
  belongs_to :vip
  belongs_to :cluster
  belongs_to :customer
  has_many :services, :through => :cluster
  has_many :assets, :through => :services
  
  validates_presence_of :name, :message => "Site name can't be blank"
  validates_format_of :name,
                      :with => /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/,
                      :message => "Site name must be a valid domain"
  
  # TODO: add state machine. States: active, inactive, dev, staging and live
  
  # Thinking Sphinx search
  define_index do
    indexes :name, :sortable => true
    indexes ip.ip, :as => :ip
    indexes cluster(:name), :as => :cluster_name
    indexes customer(:name), :as => :customer_name

    has ip_id, cluster_id, customer_id, created_at, updated_at
    
    #set_property :min_prefix_len => 3   # Minimum number of characters to index as a prefix
    #set_property :prefix_fields => 'name, hostname'  # Only do prefix indexing for specific fields
    
    set_property :min_infix_len => 2    # Minimum number of characters to index as an infix
    set_property :infix_fields => 'name, ip, cluster_name, customer_name'   # Only do infix indexing for specific fields
    
    #where "assets.state = 'active'"
  end
  
end

# == Schema Information
#
# Table name: sites
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  ip_id       :integer(4)
#  vip_id      :integer(4)
#  cluster_id  :integer(4)
#  customer_id :integer(4)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

