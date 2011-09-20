class AddFileToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :filepath, :string
  end

  def self.down
    remove_column :invoices, :filepath
  end
end
