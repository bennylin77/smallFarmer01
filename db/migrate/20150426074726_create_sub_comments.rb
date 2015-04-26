class CreateSubComments < ActiveRecord::Migration
  def change
    create_table :sub_comments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :comment, index: true
      t.text :content

      t.timestamps
    end
  end
end
