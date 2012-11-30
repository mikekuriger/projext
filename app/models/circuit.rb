class Circuit < ActiveRecord::Base
  attr_accessible :name, :description, :vendor_id, :vendor_circuit_id, :notes

  belongs_to :vendor
  
  has_paper_trail
end
