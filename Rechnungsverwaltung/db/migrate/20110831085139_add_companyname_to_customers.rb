class AddCompanynameToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :companyname, :string
  end

  def self.down
    remove_column :customers, :companyname
  end
end
