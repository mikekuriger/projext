class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :role_ids
  attr_accessible :title, :phone, :cell, :pager
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'email ASC'
  
  has_many :assignments
  has_many :roles, :through => :assignments

  # Enable versioning
  has_paper_trail
  
  # For acts_as_taggable_on
  acts_as_tagger
  
  # From friendly_id plugin (http://github.com/norman/friendly_id)
  # This breaks things for some reason, commenting for now - 2010/02/18
#  has_friendly_id :email
  
  # Overriding the Clearance authenticate method to allow only active users to have access, and eventually to allow access via API key
  # Original method (for reference):
  # def authenticate(email, password)
  #   return nil  unless user = find_by_email(email)
  #   return user if     user.authenticated?(password)
  # end
  # def self.authenticate(email, password)
  #   user = find(:first, :conditions => ['email = ? AND state = ?', email.to_s.downcase, 'active'])
  #   user && user.authenticated?(password) ? user : nil
  # end
  
  # Override the Clearance authenticated? method to authenticate via API key as well
  # Original method (for reference):
  # def authenticated?(password)
  #   encrypted_password == encrypt(password)
  # end
  ## 2010/02/15 - maybe I don't have to override this after all?
  # def authenticated?(password)
  #   if (type == 'Agent' && api_is_enabled?)
  #     logger.debug("type is #{type}, Authenticating using api key")
  #     api_key == password   # TODO: Need to add PKI logic here eventually
  #   else
  #     logger.debug("type is #{type}, Authenticating using password")
  #     encrypted_password == encrypt(password)
  #   end
  # end
  
  # user#name accessor
  def name
    email
  end
  
  def self.model_name
    name = "user"
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
    end
    return name
  end
  
  # Provides select options for forms
  def self.select_options
    subclasses.map{ |c| c.to_s }.sort
  end
  
  # add a role to the user (will not create a role if role doesn't exist)
  def add_role(role)
    role_obj = Role.find_by_name(role)
    roles.push(role_obj) unless role_obj.nil? || roles.member?(role_obj)
  end
  
  # add a role to the user (create role if it doesn't exist)
  def add_role!(role)
    role_obj = Role.find_or_create_by_name(role)
    self.add_role(role_obj.name)
  end
  
  # remove a role from the user
  def remove_role(role)
    role_obj = Role.find_by_name(role)
    roles.delete(role_obj) unless role_obj.nil?
    roles
  end
  
  ###
  # For CanCan authorization
  def is?(role)
    self.has_role?(role.to_sym)
#    roles.include?(role.to_s)
  end
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  ###
  
  ###
  # For API keys
  def enable_api!
    self.generate_api_key!
  end
 
  def disable_api!
    self.update_attribute(:api_key, "")
  end
 
  def api_is_enabled?
    !self.api_key.empty?
  end
  ###
  
  state_machine :initial => :new do
    event :activate do
      transition any => :active
    end
    
    event :disable do
      transition any => :disabled
    end
    
    state :new do
    end
    
    state :active do
    end
    
    # Users can go dormant and become inactive
    state :inactive do
    end
    
    state :disabled do
    end
  end
  
  protected
 
    ###
    # For API keys
    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end
 
    def generate_api_key!
      self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
    end
    ###
    
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  email              :string(255)
#  encrypted_password :string(128)
#  salt               :string(128)
#  confirmation_token :string(128)
#  remember_token     :string(128)
#  email_confirmed    :boolean(1)      default(FALSE), not null
#  first_name         :string(255)
#  last_name          :string(255)
#

