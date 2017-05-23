class CreateHistories < ActiveRecord::Migration[5.0]
    def change
        create_table :histories do |t|
            t.references :fandom, foreign_key: true
            t.references :user, foreign_key: true
            t.string :title
            t.datetime :event_date
            t.timestamps
        end
    end
end
