class CreateWikis < ActiveRecord::Migration[5.0]
    def change
        create_table :wikis do |t|
            t.references :fandom, foreign_key: true
            t.references :wiki, foreign_key: true
            t.string :name
            
            t.timestamps
        end
    end
end
