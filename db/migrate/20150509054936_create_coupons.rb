class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.float :amount
      t.float :original_amount
      t.integer :kind
      
      t.belongs_to :user, index: true
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
