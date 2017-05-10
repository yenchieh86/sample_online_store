class AddPicturesToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :pictures, :json
  end
end
