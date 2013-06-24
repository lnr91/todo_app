class Task < ActiveRecord::Base
  attr_accessible :completed, :description
  belongs_to :list
  validates :description, presence: true
  scope :completed, where(completed: true)
  scope :incomplete, where(completed: false )
end
