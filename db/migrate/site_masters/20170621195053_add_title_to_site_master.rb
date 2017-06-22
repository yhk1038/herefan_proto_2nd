class AddTitleToSiteMaster < ActiveRecord::Migration[5.0]
    def change
        add_column :site_masters, :title, :string, null: false, default: 'HereFan'
        add_column :site_masters, :description, :string, null: false, default: 'The fastest way to k-dol stars, HereFan'
        add_column :site_masters, :url, :string, null: false, default: 'http://test.herefan.com'
        add_column :site_masters, :home_name, :string, null: false, default: 'home'
        add_column :site_masters, :fandom_name, :string, null: false, default: 'planet'
        add_column :site_masters, :default_profile_image, :string, null: false, default: '/img/default-user-image.png'
        add_column :site_masters, :default_dummy_image, :string, null: false, default: '/svg/facebook_send.png'
    end
end
