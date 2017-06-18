class CreateWikiInfos < ActiveRecord::Migration[5.0]
    def change
        create_table :wiki_infos do |t|
            t.references :wiki, foreign_key: true
            t.string :title
            t.text :content
            t.string :url
            
            t.timestamps
        end
    end
end
