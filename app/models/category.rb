class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }
  validates :name, uniqueness: { scope: :user_id }
  validates :color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "must be a valid hex color" }
end
