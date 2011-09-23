class ChangeQtyDataType < ActiveRecord::Migration
  def self.up
     change_column :invoice_posses, :qty, :float
  end

  def self.down
     change_column :invoice_posses, :qty, :integer
  end
end
