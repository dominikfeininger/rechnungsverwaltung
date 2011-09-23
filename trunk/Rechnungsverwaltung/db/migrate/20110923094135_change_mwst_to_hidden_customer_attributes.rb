class ChangeMwstToHiddenCustomerAttributes < ActiveRecord::Migration
  def self.up
    rename_column :customer_attributes, :mwst, :hidden
  end

  def self.down
    rename_column :customer_attributes, :hidden, :mwst
  end
end
