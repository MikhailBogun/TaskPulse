class TaskSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :status, :scheduled_at, :last_run_at, :created_at, :updated_at

  association :category, blueprint: CategorySerializer
end
