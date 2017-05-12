class ChengeTotalVilumeTo < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_items, :total_volume, :decimal, precision: 7, scale: 2, default: "0.00"
    remove_column :orders, :total_volume, :decimal, precision: 7, scale: 2, default: "0.00"
    
    add_column :order_items, :total_dimensions, :decimal, precision: 10, scale: 2, default: "0.00"
    add_column :orders, :total_dimensions, :decimal, precision: 10, scale: 2, default: "0.00"
  end
end
