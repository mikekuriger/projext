class EmailsAlias < ActiveRecord::Base
  belongs_to :email
  belongs_to :alias
end
