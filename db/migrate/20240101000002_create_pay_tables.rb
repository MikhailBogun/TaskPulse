class CreatePayTables < ActiveRecord::Migration[7.2]
  def change
    create_table :pay_customers do |t|
      t.belongs_to :owner, polymorphic: true, index: false, null: false
      t.string :processor, null: false
      t.string :processor_id
      t.boolean :default, default: false, null: false
      t.public_send Pay.json_column_type, :data
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :pay_customers, [ :owner_type, :owner_id, :processor, :deleted_at ], name: "pay_customers_owner_processor_index"
    add_index :pay_customers, [ :processor, :processor_id ]

    create_table :pay_merchants do |t|
      t.belongs_to :owner, polymorphic: true, index: false, null: false
      t.string :processor, null: false
      t.string :processor_id
      t.boolean :default, default: false, null: false
      t.public_send Pay.json_column_type, :data
      t.timestamps
    end
    add_index :pay_merchants, [ :owner_type, :owner_id, :processor ]
    add_index :pay_merchants, [ :processor, :processor_id ]

    create_table :pay_payment_methods do |t|
      t.belongs_to :customer, null: false
      t.string :processor_id
      t.boolean :default, default: false, null: false
      t.string :payment_method_type
      t.public_send Pay.json_column_type, :data
      t.timestamps
    end
    add_index :pay_payment_methods, [ :customer_id, :processor_id ], unique: true

    create_table :pay_subscriptions do |t|
      t.belongs_to :customer, null: false
      t.string :name, null: false
      t.string :processor_id, null: false
      t.string :processor_plan, null: false
      t.integer :quantity, default: 1, null: false
      t.string :status, null: false
      t.public_send Pay.json_column_type, :data
      t.boolean :metered, default: false
      t.string :pause_behavior
      t.datetime :pause_starts_at
      t.datetime :pause_resumes_at
      t.decimal :application_fee_percent, precision: 8, scale: 2
      t.datetime :trial_ends_at
      t.datetime :ends_at
      t.boolean :on_trial, default: false
      t.timestamps
    end
    add_index :pay_subscriptions, [ :customer_id, :processor_id ], unique: true
    add_index :pay_subscriptions, :status

    create_table :pay_charges do |t|
      t.belongs_to :customer, null: false
      t.belongs_to :subscription, null: true
      t.string :processor_id, null: false
      t.integer :amount, null: false
      t.string :currency
      t.integer :application_fee_amount
      t.decimal :amount_refunded
      t.public_send Pay.json_column_type, :data
      t.datetime :refunded_at
      t.datetime :disputed_at
      t.timestamps
    end
    add_index :pay_charges, [ :customer_id, :processor_id ], unique: true

    create_table :pay_webhooks do |t|
      t.string :processor
      t.string :event_type
      t.public_send Pay.json_column_type, :event
      t.timestamps
    end
  end
end
