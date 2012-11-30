require 'test_helper'

class PurchaseOrderTest < ActiveSupport::TestCase
  should_belong_to :vendor

  should_validate_presence_of :name, :message => "Purchase order name can't be blank"
  should_validate_uniqueness_of :number, :scoped_to => :vendor_id, :message => "Purchase order already exists"
end

# == Schema Information
#
# Table name: purchase_orders
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  description             :string(255)
#  created                 :date
#  sent                    :date
#  vendor_id               :integer(4)
#  number                  :string(255)
#  amount                  :float
#  notes                   :text
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :string(255)
#  attachment_updated_at   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

