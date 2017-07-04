class AddPublishedUpdatedAtToFandom < ActiveRecord::Migration[5.0]
  def change
    add_column :fandoms, :published_updated_at, :datetime
  end
end
