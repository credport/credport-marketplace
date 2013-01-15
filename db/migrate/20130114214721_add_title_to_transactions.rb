class AddTitleToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :guest_text, :text
    add_column :transactions, :guest_rating, :integer
    add_column :transactions, :host_text, :text
    add_column :transactions, :host_rating, :integer
  end
end
