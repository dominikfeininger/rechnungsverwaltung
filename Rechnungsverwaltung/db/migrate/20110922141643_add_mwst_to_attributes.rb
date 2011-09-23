class AddMwstToAttributes < ActiveRecord::Migration
  def self.up
    add_column :customer_attributes, :mwst, :boolean
  end

  def self.down
    remove_column :customer_attributes, :mwst
  end
end
