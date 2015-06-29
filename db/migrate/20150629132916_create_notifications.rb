class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :category
      t.integer :sub_category
      t.string :content
      t.belongs_to :order, index: true
      t.belongs_to :user, index: true
      t.belongs_to :comment, index: true
      t.belongs_to :product, index: true
      t.belongs_to :invoice, index: true

      t.timestamps
    end
  end
end
