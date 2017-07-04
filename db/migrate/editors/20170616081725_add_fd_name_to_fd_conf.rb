class AddFdNameToFdConf < ActiveRecord::Migration[5.0]
  def change
    add_column :fd_confs, :fd_name, :string
  end
end
