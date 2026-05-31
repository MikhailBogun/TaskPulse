class CategorySerializer < Blueprinter::Base
  identifier :id

  fields :name, :color, :created_at
end
