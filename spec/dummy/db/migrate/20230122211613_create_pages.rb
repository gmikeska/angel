class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :controller
      t.string :action
      t.string :settings_data
      t.timestamps
    end
  end
end
