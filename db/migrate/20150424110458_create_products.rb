class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :inventory
      t.boolean :delete_c
      t.boolean :available_c
      t.belongs_to :company, index: true

      t.timestamps
    end
  end
end
