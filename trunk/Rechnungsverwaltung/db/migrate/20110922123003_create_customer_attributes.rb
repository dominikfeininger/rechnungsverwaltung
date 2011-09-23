class CreateCustomerAttributes < ActiveRecord::Migration
  def self.up
    create_table :customer_attributes do |t|
      t.string :key
      t.boolean :val
      t.references :customer

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_attributes
  end
end
