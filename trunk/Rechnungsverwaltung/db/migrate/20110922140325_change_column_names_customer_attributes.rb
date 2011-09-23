class ChangeColumnNamesCustomerAttributes < ActiveRecord::Migration
  def self.up
    rename_column :customer_attributes, :key, :mwst
    rename_column :customer_attributes, :val, :logo
    add_column :customer_attributes, :address, :boolean
    add_column :customer_attributes, :signature, :boolean
    add_column :customer_attributes, :footer, :boolean
    add_column :customer_attributes, :unitprice, :boolean            
  end

  def self.down
    rename_column :customer_attributes, :mwst, :key
    rename_column :customer_attributes, :logo, :val
    remove_column :customer_attributes, :address
    remove_column :customer_attributes, :signature
    remove_column :customer_attributes, :footer
    remove_column :customer_attributes, :unitprice    
  end
end
