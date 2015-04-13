class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.attachment :cover
      t.string :name
      t.text :description
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
