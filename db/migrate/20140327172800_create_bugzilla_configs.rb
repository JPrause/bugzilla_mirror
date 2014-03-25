class CreateBugzillaConfigs < ActiveRecord::Migration
  def change
    create_table :bugzilla_configs do |t|
      t.string     :name,   :null => false
      t.string     :value
    end

    add_index    :bugzilla_configs,  :name,  :unique => true
  end
end
