class AddOrderItemsCountToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :order_items_count, :integer
  end
end
