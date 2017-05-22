class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.references :user, foreign_key: true
      t.references :fandom, foreign_key: true
      t.integer :type   # 1: photo / 2: video / 3: others
      t.string :url
      t.string :title
      t.string :description
      t.string :message
      t.string :image

      t.timestamps
    end
  end
end
