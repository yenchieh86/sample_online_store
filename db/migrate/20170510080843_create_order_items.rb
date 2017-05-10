class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :quantity, default: 0
      t.decimal :total_weight, default: 0.00, precision: 7, scale: 2
      t.decimal :total_volume, default: 0.00, precision: 7, scale: 2
      t.integer :status, default: 0
      t.decimal :total_amount, default: 0.00, precision: 7, scale: 2

      t.timestamps
    end
    add_index :order_items, :status
  end
end
