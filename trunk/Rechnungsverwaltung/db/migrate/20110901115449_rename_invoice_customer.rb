class RenameInvoiceCustomer < ActiveRecord::Migration
  def self.up
    rename_column :invoices, :customers_id, :customer_id
  end

  def self.down
    rename_column :invoices, :customer_id, :customers_id
  end
end