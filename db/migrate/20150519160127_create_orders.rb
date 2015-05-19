class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :receiver_last_name
      t.string :receiver_first_name

      t.timestamps
    end
  end
end
