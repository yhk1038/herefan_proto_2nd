class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.references :link, foreign_key: true
      t.references :wiki_post, foreign_key: true
      t.references :history, foreign_key: true
      t.references :schedule, foreign_key: true
      t.references :fandom, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
