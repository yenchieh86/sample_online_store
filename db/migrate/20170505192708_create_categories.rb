class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""
      t.integer :items_count, default: 0

      t.timestamps
    end
    
    add_index :categories, :title, unique: true
  end
end
