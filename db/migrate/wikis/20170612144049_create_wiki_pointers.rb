class CreateWikiPointers < ActiveRecord::Migration[5.0]
    def change
        create_table :wiki_pointers do |t|
            t.references :wiki, foreign_key: true
            t.integer :sort_num, null: false, default: 999999
            
            t.timestamps
        end
    end
end
