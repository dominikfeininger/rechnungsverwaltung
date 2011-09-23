class ChangeCustomerAttributesDataTypes < ActiveRecord::Migration
  def self.up
     change_column :customer_attributes, :logo, :string
     change_column :customer_attributes, :signature, :string
     change_column :customer_attributes, :address, :string
     change_column :customer_attributes, :footer, :string
     change_column :customer_attributes, :unitprice, :string
  end

  def self.down
          change_column :customer_attributes, :logo, :boolean
     change_column :customer_attributes, :signature, :boolean
     change_column :customer_attributes, :address, :boolean
     change_column :customer_attributes, :footer, :boolean
     change_column :customer_attributes, :unitprice, :boolean
  end
end
