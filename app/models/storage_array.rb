class StorageArray < Asset
  attr_accessible :name, :description
  attr_accessible :storage_heads_attributes
  attr_accessible :storage_shelves_attributes
  
  has_many :storage_heads, :dependent => :restrict    # We don't want to orphan storage heads/shelves
  has_many :storage_shelves, :dependent => :restrict
  
  belongs_to :farm
  
  validates_presence_of :name, :message => "Storage array name must exist"
  validates_uniqueness_of :name, :message => "Storage array name must be unique"
  
  accepts_nested_attributes_for :storage_heads,
                                :reject_if => lambda { |a| a[:name].blank? },
                                :allow_destroy => true
  accepts_nested_attributes_for :storage_shelves,
                                :reject_if => lambda { |a| a[:name].blank? },
                                :allow_destroy => true
  
  has_paper_trail
  
  def total_disks
    total_disks = 0
    storage_shelves.each {|shelf| total_disks += shelf.disk_count}
    total_disks
  end
end
