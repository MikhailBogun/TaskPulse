class CreateTaskLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :task_logs do |t|
      t.references :task,     null: false, foreign_key: true
      t.string :status,       null: false
      t.text :output
      t.decimal :duration_seconds, precision: 10, scale: 3
      t.timestamps
    end

    # Composite index for the analytics dashboard query — prevents Seq Scan
    add_index :task_logs, [ :task_id, :status, :created_at ]
    add_index :task_logs, :created_at
  end
end
