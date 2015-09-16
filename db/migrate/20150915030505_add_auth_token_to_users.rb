class AddAuthTokenToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :authentication_token
      t.datetime :authentication_token_expires_at
    end
    add_index  :users, :authentication_token, :unique => true
  end

  def self.down
    remove_column :users, :authentication_token
    remove_column :users, :authentication_token_expires_at
  end
end
