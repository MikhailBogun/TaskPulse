module Tasks
  class CreateTask < ApplicationService
    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      check_plan_limit!
      @user.tasks.create!(@params)
    end

    private

    def check_plan_limit!
      limit = @user.plan_limit(:tasks)
      current_count = @user.tasks.count
      if current_count >= limit
        raise ActiveRecord::RecordInvalid.new(
          Task.new.tap { |t| t.errors.add(:base, "Task limit reached for your plan (#{limit} tasks). Upgrade to add more.") }
        )
      end
    end
  end
end
