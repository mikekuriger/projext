class ParameterAssignment < ActiveRecord::Base
  attr_accessible :assignable_id, :assignable_type, :name, :parameter, :parameter_id, :value

  belongs_to :assignable, :polymorphic => true
  belongs_to :parameter
  
  has_paper_trail
  
  def name
    parameter.name unless parameter.name.nil?
  end
end
