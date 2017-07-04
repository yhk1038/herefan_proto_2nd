class CreateSiteMasters < ActiveRecord::Migration[5.0]
  def change
    create_table :site_masters do |t|
      t.string :message_login_please
      t.string :message_global_error
      t.integer :fandom_publish_count

      t.timestamps
    end
  end
end
