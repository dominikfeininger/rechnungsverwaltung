class CreateFilePaths < ActiveRecord::Migration
  def self.up
    create_table :file_paths do |t|
      t.string :path
      t.references :invoice

      t.timestamps
    end
  end

  def self.down
    drop_table :file_paths
  end
end
