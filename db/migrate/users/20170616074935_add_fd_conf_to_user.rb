class AddFdConfToUser < ActiveRecord::Migration[5.0]
    def change
        add_reference :users, :fd_conf, foreign_key: true
    end
end
