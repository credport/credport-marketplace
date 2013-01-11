class AddCredportTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credport_token, :string
  end
end
