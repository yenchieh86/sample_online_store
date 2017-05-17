class AddTrackingNumberToShippingInformations < ActiveRecord::Migration[5.0]
  def change
    add_column :shipping_informations, :tracking_number, :string, default: ''
    remove_column :users, :orders_count, :integer
    add_column :users, :orders_count, :integer, default: 0
  end
end
