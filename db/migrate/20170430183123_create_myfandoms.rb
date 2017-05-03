class CreateMyfandoms < ActiveRecord::Migration[5.0]
  def change
    create_table :myfandoms do |t|
      t.references :fandom, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
