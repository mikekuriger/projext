require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  should belong_to :vendor

  should have_many :assets_contracts
  should have_many :assets

  should validate_presence_of :name
  should validate_uniqueness_of :number
end

# == Schema Information
#
# Table name: contracts
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  type                    :string(255)     default("Contract")
#  description             :string(255)
#  number                  :string(255)
#  supportlevel            :string(255)
#  vendor_id               :integer(4)
#  start                   :date
#  end                     :date
#  quote_id                :integer(4)
#  purchaseorder_id        :integer(4)
#  notes                   :text
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer(4)
#  attachment_updated_at   :datetime
#

