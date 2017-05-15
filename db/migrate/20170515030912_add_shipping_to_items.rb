class AddShippingToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :shipping, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :order_items, :shipping, :decimal, precision: 7, scale: 2, default: 0.0
  end
end
