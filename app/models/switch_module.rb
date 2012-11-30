class SwitchModule < Asset
  # Attributes
  attr_accessible :name, :description, :serial, :hardware_model_id
  attr_accessible :interfaces_attributes

  # Relationships
  belongs_to :hardware_model
  belongs_to :switch

  # Nested attributes
  accepts_nested_attributes_for :interfaces,
                                :reject_if => lambda { |a| a[:name].blank? },
                                :allow_destroy => true

  has_paper_trail
end
