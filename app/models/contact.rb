class Contact < ActiveRecord::Base
  attr_accessible :first_name, :middle_name, :last_name, :phone, :cell, :email, :notes, :title, :app_ids

  has_many :contacts_customers
  has_many :customers, :through => :contacts_customers
  has_many :apps_contacts
  has_many :apps, :through => :apps_contacts
  
  validates_presence_of :first_name, :on => :create, :message => "First name cannot be blank"
  validates_presence_of :last_name, :on => :create, :message => "Last name cannot be blank"
  
  has_paper_trail
  
  def name
    "#{first_name} #{last_name}"
  end
end
