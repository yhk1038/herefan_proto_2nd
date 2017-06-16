class CreateFandoms < ActiveRecord::Migration[5.0]
    def change
        create_table :fandoms do |t|
            t.string :name
            t.string :profile_img
            t.string :background_img
            
            t.boolean :published,           null: false, default: false
            
            t.timestamps
        end
    end
end