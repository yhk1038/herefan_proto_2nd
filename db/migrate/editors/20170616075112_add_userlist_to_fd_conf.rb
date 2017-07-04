class AddUserlistToFdConf < ActiveRecord::Migration[5.0]
    def change
        add_column :fd_confs, :userlist, :text, null: false, default: '[]'
        remove_column :fd_confs, :userlists
    end
end
