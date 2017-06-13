class CreateWikiPosts < ActiveRecord::Migration[5.0]
    def change
        create_table :wiki_posts do |t|
            t.references :user, foreign_key: true, null: false
            t.references :wiki, foreign_key: true
            t.string :title
            t.text :content
            t.string :commit_msg
            t.integer :row_count, null: false, default: 999999
            t.string :url
            
            t.timestamps
        end
    end
end
