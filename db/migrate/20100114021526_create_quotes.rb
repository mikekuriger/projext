class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string :name
      t.string :description
      t.date :date
      t.date :expiration
      t.references :vendor
      t.string :number
      t.text :notes
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.string :attachment_file_size
      t.string :attachment_updated_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :quotes
  end
end
