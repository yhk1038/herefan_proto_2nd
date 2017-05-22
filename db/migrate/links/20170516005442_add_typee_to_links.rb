class AddTypeeToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :typee, :integer, null: false, default: 0
  end
end
