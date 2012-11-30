class Domain < ActiveRecord::Base
  attr_accessible :name, :customer_id
  
  belongs_to :customer
end
