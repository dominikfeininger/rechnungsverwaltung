class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :plz
      t.string :city
      t.references :customer

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
