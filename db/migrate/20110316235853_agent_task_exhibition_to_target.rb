class AgentTaskExhibitionToTarget < ActiveRecord::Migration
  def self.up
    rename_column :agent_tasks, :exhibition_id, :target_id
    add_column :agent_tasks, :target_type, :string, :limit => 30, :null => false
    execute "UPDATE agent_tasks SET target_type='Exhibition'"
  end

  def self.down
    rename_column :agent_tasks, :target_id, :exhibition_id
    remove_column :agent_tasks, :target_type
  end
end
