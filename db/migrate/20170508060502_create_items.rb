class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.decimal :price, default: 0.00, precision: 5, scale: 2
      t.integer :stock, default: 0
      t.decimal :weight, default: 0.00, precision: 5, scale: 2
      t.decimal :length, default: 0.00, precision: 5, scale: 2
      t.decimal :width, default: 0.00, precision: 5, scale: 2
      t.decimal :height, default: 0.00, precision: 5, scale: 2
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.integer :sold, default: 0
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    
    add_index :items, :title, unique: true
    add_column :users, :items_count, :integer, default: 0
    add_index :items, :status
  end
end
