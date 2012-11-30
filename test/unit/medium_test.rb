require 'test_helper'

class MediumTest < ActiveSupport::TestCase
  should_have_many :cables
  should_validate_presence_of :name, :message => "Medium name can't be blank"
end

# == Schema Information
#
# Table name: media
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

