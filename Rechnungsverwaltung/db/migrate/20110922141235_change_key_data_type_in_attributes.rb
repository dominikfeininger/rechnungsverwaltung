class ChangeKeyDataTypeInAttributes < ActiveRecord::Migration
  def self.up
    remove_column :customer_attributes, :mwst
  end

  def self.down
    add_column :customer_attributes, :mwst, :string
  end
end
