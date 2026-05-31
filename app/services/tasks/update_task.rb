module Tasks
  class UpdateTask < ApplicationService
    def initialize(task:, params:)
      @task = task
      @params = params
    end

    def call
      @task.update!(@params)
      @task
    end
  end
end
