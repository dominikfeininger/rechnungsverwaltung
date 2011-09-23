class AddScaleToInvoice < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE invoice_posses ALTER COLUMN unitprice TYPE numeric(1000,2)"
    execute "ALTER TABLE invoice_posses ALTER COLUMN total TYPE numeric(1000,2)"
  end

  def self.down
    execute "ALTER TABLE invoice_posses ALTER COLUMN unitprice TYPE numeric"
    execute "ALTER TABLE invoice_posses ALTER COLUMN total TYPE numeric"
  end
end
