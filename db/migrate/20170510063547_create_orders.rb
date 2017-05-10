class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.integer :order_items_count, default: 0
      t.decimal :shipping, default: 0.00, precision: 7, scale: 2
      t.decimal :total_weight, default: 0.00, precision: 7, scale: 2
      t.decimal :total_volume, default: 0.00, precision: 7, scale: 2
      t.decimal :tax, default: 0.00, precision: 7, scale: 2
      t.decimal :order_items_total, default: 0.00, precision: 7, scale: 2
      t.decimal :order_total_amount, default: 0.00, precision: 7, scale: 2

      t.timestamps
    end
    add_index :orders, :status
  end
end
