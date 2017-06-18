class AddImageToWiki < ActiveRecord::Migration[5.0]
    def change
        add_column :wikis, :image, :string, null: false, default: '/svg/facebook_send.png'
    end
end
