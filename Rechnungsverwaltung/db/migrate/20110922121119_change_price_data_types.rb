class ChangePriceDataTypes < ActiveRecord::Migration
  def self.up
    change_column :invoice_posses, :unitprice, :float
    change_column :invoice_posses, :total, :float
  end

  def self.down
    change_column :invoice_posses, :unitprice, :decimal
    change_column :invoice_posses, :total, :decimal
  end
end
