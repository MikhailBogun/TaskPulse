class AddGithubToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :github_username, :string
    add_column :users, :telegram_chat_id, :string
    add_column :users, :slack_webhook_url, :string
    add_index :users, :github_username
  end
end
