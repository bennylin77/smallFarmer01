class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :inventory
      t.integer :unit      
      t.boolean :delete_c, default: false, null: false
      t.boolean :available_c, default: false, null: false
      t.belongs_to :company, index: true
      t.text :preservation

      t.integer :sweet_degree
      t.boolean :GMP_c

      t.timestamps
    end
  end
end
