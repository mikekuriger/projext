require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  should_belong_to :vendor

  should_validate_presence_of :name, :message => "Quote name can't be blank"
  should_validate_uniqueness_of :number, :scoped_to => :vendor_id, :message => "Quote already exists"
end

# == Schema Information
#
# Table name: quotes
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  description             :string(255)
#  date                    :date
#  expiration              :date
#  vendor_id               :integer(4)
#  number                  :string(255)
#  notes                   :text
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :string(255)
#  attachment_updated_at   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

