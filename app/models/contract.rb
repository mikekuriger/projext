class Contract < ActiveRecord::Base
  attr_accessible :name, :description, :number, :supportlevel, :vendor_id, :start, :end, 
                  :quote_id, :purchaseorder_id, :notes, :attachment,
                  :documents_attributes
  
  has_many :assets_contracts
  has_many :assets, :through => :assets_contracts
    
  belongs_to :vendor
  belongs_to :purchase_order
  belongs_to :quote
  
  validates_presence_of :name, :message => "Contract name can't be blank"
  validates_uniqueness_of :number, :scope => :vendor_id, :message => "Contract already exists"
  
  # By default, we want records ordered by number, ascending
  default_scope :order => 'number ASC'
  
  has_paper_trail
  
  acts_as_polymorphic_paperclip
  
  accepts_nested_attributes_for :documents
  
  # has_attached_file :attachment, :url => '/:class/download/:id.:extension',
  #                                :path => ':rails_root/files/:class/:id_partition/:style.:extension',
  #                                :styles => { :small => "150x150>" },
  #                                :whiny => false
  # #validates_attachment_presence :attachment
  # validates_attachment_content_type :attachment, :content_type => [ 'application/pdf', 'application/x-pdf', 'application/rtf' ]
  # validates_attachment_size :attachment, :less_than => 20.megabytes
end

# == Schema Information
#
# Table name: contracts
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  type                    :string(255)     default("Contract")
#  description             :string(255)
#  number                  :string(255)
#  supportlevel            :string(255)
#  vendor_id               :integer(4)
#  start                   :date
#  end                     :date
#  quote_id                :integer(4)
#  purchaseorder_id        :integer(4)
#  notes                   :text
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer(4)
#  attachment_updated_at   :datetime
#

