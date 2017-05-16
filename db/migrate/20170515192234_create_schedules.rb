class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.references :fandom, foreign_key: true
      t.string :category
      t.string :title
      t.text :content
      t.datetime :event_start
      t.datetime :event_end
      t.string :url
      t.string :class_name

      t.timestamps
    end
  end
end
