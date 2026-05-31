class CreateAlertRules < ActiveRecord::Migration[7.2]
  def change
    create_table :alert_rules do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :rule_type, null: false       # crypto, github
      t.string :condition, null: false       # below, above
      t.decimal :threshold, precision: 20, scale: 8
      t.string :notification_channel        # telegram, slack
      t.boolean :active, default: true
      t.datetime :last_triggered_at
      t.timestamps
    end

    add_index :alert_rules, [:user_id, :active]
    add_index :alert_rules, [:rule_type, :active]
  end
end
