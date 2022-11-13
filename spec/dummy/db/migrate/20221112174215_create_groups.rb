class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :settings_data
      t.references :page
      t.timestamps
    end
  end
end
