class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :category, null: true,  foreign_key: true
      t.string :name,         null: false
      t.text :description
      t.integer :status,      null: false, default: 0
      t.datetime :scheduled_at
      t.datetime :last_run_at
      t.timestamps
    end

    add_index :tasks, [:user_id, :status]
    add_index :tasks, [:user_id, :scheduled_at]
  end
end
