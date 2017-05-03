class CreateFandoms < ActiveRecord::Migration[5.0]
    def change
        create_table :fandoms do |t|
            t.string :name
            t.string :profile_img
            t.string :background_img
            
            t.timestamps
        end
    end
end
