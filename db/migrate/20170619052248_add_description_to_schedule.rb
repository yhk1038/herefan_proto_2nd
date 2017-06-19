class AddDescriptionToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :description, :text
  end
end
