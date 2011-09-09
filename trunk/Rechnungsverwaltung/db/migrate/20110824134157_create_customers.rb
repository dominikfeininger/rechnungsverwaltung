class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :firstname
      t.string :lastname
      t.references :addresses
      t.references :invoices

	  
	    
      t.timestamps
    end
  end

  
  
  def self.down
    drop_table :customers
  end
end
 