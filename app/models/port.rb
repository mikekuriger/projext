class Port < ActiveRecord::Base
  attr_accessible :name, :description, :protocol, :begin_port, :end_port

  has_paper_trail
end
