class CreateAgentTasks < ActiveRecord::Migration
  def self.up
    create_table :agent_tasks do |t|
      t.integer :agent_id
      t.integer :exhibition_id, :null => false
      t.integer :media_service_id, :null => false
      t.string :status, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :agent_tasks
  end
end
