class CreateFdConfs < ActiveRecord::Migration[5.0]
    def change
        create_table :fd_confs do |t|
            t.references :fandom, foreign_key: true
            t.references :user, foreign_key: true
            t.text :userlists
            t.string :fd_logo
            t.string :fd_bg_img
            t.string :fd_bg_color
            
            t.timestamps
        end
    end
end
