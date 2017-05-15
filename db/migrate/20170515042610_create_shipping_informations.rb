class CreateShippingInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_informations do |t|
      t.references :order, foreign_key: true
      t.string :firmname, default: '', null: false
      t.string :address1, default: ''
      t.string :address2, default: '', null: false
      t.string :city, default: '', null: false
      t.string :state, default: '', null: false
      t.string :zip5, default: '', null: false
      t.string :zip4, default: ''
      t.string :delivery_point, default: ''
      t.string :carrier_route, default: ''
      
      t.timestamps
    end
  end
end
