class AddEmailToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :email, :string
  end

  def self.down
    remove_column :customer, email
  end
end
