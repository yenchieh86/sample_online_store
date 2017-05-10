class CreateStoreActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :store_activities do |t|
      t.integer :total_users, default: 0
      t.integer :total_categories, default: 0
      t.integer :total_items, default: 0
      t.integer :total_orders, default: 0
      t.integer :total_finished_order, default: 0
      t.decimal :total_sales, default: 0.00, precision: 7, scale: 2

      t.timestamps
    end
  end
end
