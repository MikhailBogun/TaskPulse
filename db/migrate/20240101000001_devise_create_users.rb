class DeviseCreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email

      # JWT revocation
      t.string :jti, null: false

      # Plan
      t.integer :plan, null: false, default: 1
      t.datetime :trial_ends_at
      t.datetime :grace_period_ends_at

      # Pay gem fields
      t.string :stripe_customer_id
      t.string :stripe_subscription_id

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :jti,                  unique: true
    add_index :users, :plan
  end
end
