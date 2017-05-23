class AddImgToHistory < ActiveRecord::Migration[5.0]
    def change
        add_column :histories, :history_id, :integer
        add_column :histories, :img, :string
        add_column :histories, :thumb_img, :string
    end
end
