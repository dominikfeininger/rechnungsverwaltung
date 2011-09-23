class AddMwstToInvoicePoss < ActiveRecord::Migration
  def self.up
    add_column :invoice_posses, :mwst, :float
  end

  def self.down
    remove_column :invoice_posses, :mwst
  end
end
