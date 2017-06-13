class AddWikiPointerToWikiPost < ActiveRecord::Migration[5.0]
    def change
        add_reference :wiki_posts, :wiki_pointer, foreign_key: true, null: false, default: 1
    end
end
