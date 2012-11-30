require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  should_belong_to :vendor

  should_have_many :assets_contracts
  should_have_many :assets, :through => :assets_contracts

  should_validate_presence_of :name, :message => "Contract name can't be blank"
  should_validate_uniqueness_of :number, :scoped_to => :vendor_id, :message => "Contract already exists"
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

