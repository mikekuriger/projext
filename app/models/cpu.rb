class Cpu < ActiveRecord::Base
  # Named Cpu because Processor conflicted with Paperclip
  attr_accessible :manufacturer, :manufacturer_id, :cpu_type, :cores, :speed

  belongs_to :manufacturer
  has_many :assets
  
  # validates_presence_of :manufacturer_id, :message => "Manufacturer can't be blank"
  validates_presence_of :cpu_type, :message => "CPU type can't be blank"
  # validates_presence_of :cores, :message => "Cores can't be blank"
  # validates_presence_of :speed, :message => "Speed can't be blank"
  
  validates_uniqueness_of :speed, :scope => [ :manufacturer_id, :cpu_type, :cores ], :message => "Duplicate CPU"
  
  has_paper_trail
  
  def name
    cpu_type
  end
  
  def to_s
    to_label
  end
  
  def to_label
    "#{manufacturer.try(:name)} #{cpu_type} #{speed} (#{cores} cores)"
  end
end
