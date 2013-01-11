class AddDescriptionToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :description, :text, :default => ''
  end
end
