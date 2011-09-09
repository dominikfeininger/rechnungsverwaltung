class CreateInvoicePosses < ActiveRecord::Migration
  def self.up
    create_table :invoice_posses do |t|
      t.string :invoiceposnr
      t.text :description
      t.integer :qty
      t.decimal :unitprice
      t.decimal :total
      t.references :invoice

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_posses
  end
end
