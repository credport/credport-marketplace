class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :booker_id
      t.integer :bookee_id
      t.integer :property_id

      t.timestamps
    end
  end
end
