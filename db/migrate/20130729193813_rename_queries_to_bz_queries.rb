class RenameQueriesToBzQueries < ActiveRecord::Migration
  def up
    rename_table :queries, :bz_queries
  end

  def down
    rename_table :bz_queries, :queries
  end
end
