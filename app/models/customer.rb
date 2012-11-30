class Customer < ActiveRecord::Base
  has_many :projects
  has_many :apps, :through => :projects
  has_many :contacts_customers
  has_many :contacts, :through => :contacts_customers
  has_many :sites

  validates_presence_of :name
  validates_associated :projects
  
  validates_format_of :zip,
                      :with => %r{\d{5}(-\d{4})?},
                      :message => "should be 12345 or 12345-1234",
                      :allow_blank => true
  validates_format_of :url,
                      :with => URI::regexp(%w(http https)),
                      :message => "URL must be valid",
                      :allow_blank => true
end

# == Schema Information
#
# Table name: customers
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  address1      :string(255)
#  address2      :string(255)
#  city          :string(255)
#  state         :string(255)
#  zip           :string(255)
#  url           :string(255)
#  contact1name  :string(255)
#  contact1phone :string(255)
#  contact1cell  :string(255)
#  contact1email :string(255)
#  contact2name  :string(255)
#  contact2phone :string(255)
#  contact2cell  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  notes         :string(255)
#

