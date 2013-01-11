class AddCredportUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credport_uid, :string
  end
end
