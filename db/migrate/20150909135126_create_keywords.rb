class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string   :content
      t.integer  :kind, default: 0, null: false      
      t.integer  :search_count, default: 0, null: false      
      t.timestamps
    end
  end
end
