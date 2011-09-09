class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :invoicenr
      t.references :customers
      t.references :invoice_posses
      
      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
