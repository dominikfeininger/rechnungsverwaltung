class AddDateToinvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :date, :string 
  end

  def self.down
    remove_column :invoices, :date
  end
end
