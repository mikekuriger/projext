class HardwareModel < ActiveRecord::Base
  attr_accessible :name, :description, :manufacturer, :manufacturer_id, :rackunits
  attr_accessible :picture, :rack_front, :rack_rear
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  has_many :assets
  belongs_to :manufacturer
  
  validates_presence_of :name, :message => "Hardware model name can't be blank"
  
  has_attached_file :picture,
                    :styles => { :thumb => "64x64#",
                                 :tiny => "64x64>",
                                 :small => "176x112>",
                                 :medium => "630x630>",
                                 :large => "1024x1024>" }
                    # :url => "/:class/:id/:style.:extension",
                    # :path => ":rails_root/assets/:class/:id/:style/:basename.:extension"
  has_attached_file :rack_front,
                    :styles => { :thumb => "64x64#",
                                 :tiny => "64x64>",
                                 :small => "176x112>",
                                 :medium => "630x630>",
                                 :large => "1024x1024>" }
                    # :url => "/:class/:id/:style.:extension",
                    # :path => ":rails_root/assets/:class/:id/:style/:basename.:extension"
  has_attached_file :rack_rear,
                    :styles => { :thumb => "64x64#",
                                 :tiny => "64x64>",
                                 :small => "176x112>",
                                 :medium => "630x630>",
                                 :large => "1024x1024>" }
                    # :url => "/:class/:id/:style.:extension",
                    # :path => ":rails_root/assets/:class/:id/:style/:basename.:extension"
                                 
  
end
