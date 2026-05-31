class GithubSyncJob < ApplicationJob
  queue_as :low

  def perform
    User.where.not(github_username: nil).find_each do |user|
      Github::FetchRepoStats.call(user: user)
    rescue StandardError => e
      Rails.logger.error("GithubSyncJob failed for user #{user.id}: #{e.message}")
    end
  end
end
