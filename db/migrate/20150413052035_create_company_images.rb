class CreateCompanyImages < ActiveRecord::Migration
  def change
    create_table :company_images do |t|
      t.attachment :image
      t.belongs_to :company, index: true

      t.timestamps
    end
  end
end
