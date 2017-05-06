class CreateVisitedLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :visited_links do |t|
      t.references :user, foreign_key: true
      t.references :link, foreign_key: true
      t.integer :viewcount

      t.timestamps
    end
  end
end
