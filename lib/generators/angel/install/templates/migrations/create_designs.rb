class CreateDesigns < ActiveRecord::Migration[7.0]
  def change
    create_table :designs do |t|
      t.string :name, uniq:true
      t.string :slug, uniq:true
      t.string :component_name
      t.string :options_data
      t.string :user_options_data
      t.string :defaults_data
      t.references :page
      t.timestamps
    end
  end
end
