class PurchaseOrder < ActiveRecord::Base
  attr_accessible :name, :description, :created, :sent, :vendor_id, :number, :amount, :notes, :attachment,
                  :documents_attributes

  belongs_to :vendor
  has_many :contracts
  
  validates_presence_of :name, :message => "Purchase order name can't be blank"
  validates_uniqueness_of :number, :scope => :vendor_id, :message => "Purchase order already exists"
  
  # By default, we want records ordered by name, ascending
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
# Table name: purchase_orders
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  description             :string(255)
#  created                 :date
#  sent                    :date
#  vendor_id               :integer(4)
#  number                  :string(255)
#  amount                  :float
#  notes                   :text
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :string(255)
#  attachment_updated_at   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

