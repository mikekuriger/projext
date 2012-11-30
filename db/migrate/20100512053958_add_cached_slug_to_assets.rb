class AddCachedSlugToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :cached_slug, :string
  end

  def self.down
    remove_column :assets, :cached_slug
  end
end
