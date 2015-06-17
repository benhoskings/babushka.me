class DropTables < ActiveRecord::Migration
  def up
    drop_table :deps
    drop_table :runs
    drop_table :sources
  end
end
