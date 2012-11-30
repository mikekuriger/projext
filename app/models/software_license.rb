class SoftwareLicense < Asset
  attr_accessible :name, :description

  has_paper_trail
end
