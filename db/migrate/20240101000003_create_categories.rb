class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color, default: "#6366f1"
      t.timestamps
    end

    add_index :categories, [:user_id, :name], unique: true
  end
end
