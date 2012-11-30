class AddAttachmentsPictureRackFrontAndRackRearToHardwareModel < ActiveRecord::Migration
  def self.up
    add_column :hardware_models, :picture_file_name, :string
    add_column :hardware_models, :picture_content_type, :string
    add_column :hardware_models, :picture_file_size, :integer
    add_column :hardware_models, :picture_updated_at, :datetime
    add_column :hardware_models, :rack_front_file_name, :string
    add_column :hardware_models, :rack_front_content_type, :string
    add_column :hardware_models, :rack_front_file_size, :integer
    add_column :hardware_models, :rack_front_updated_at, :datetime
    add_column :hardware_models, :rack_rear_file_name, :string
    add_column :hardware_models, :rack_rear_content_type, :string
    add_column :hardware_models, :rack_rear_file_size, :integer
    add_column :hardware_models, :rack_rear_updated_at, :datetime
  end

  def self.down
    remove_column :hardware_models, :picture_file_name
    remove_column :hardware_models, :picture_content_type
    remove_column :hardware_models, :picture_file_size
    remove_column :hardware_models, :picture_updated_at
    remove_column :hardware_models, :rack_front_file_name
    remove_column :hardware_models, :rack_front_content_type
    remove_column :hardware_models, :rack_front_file_size
    remove_column :hardware_models, :rack_front_updated_at
    remove_column :hardware_models, :rack_rear_file_name
    remove_column :hardware_models, :rack_rear_content_type
    remove_column :hardware_models, :rack_rear_file_size
    remove_column :hardware_models, :rack_rear_updated_at
  end
end
