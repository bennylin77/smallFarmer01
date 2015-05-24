class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :payment_method
      t.float :amount
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
