class List < ActiveRecord::Base
  attr_accessible :description, :name
  validates :description,:name, presence: true
  has_many :tasks ,dependent: :destroy   # destroy associated tasks also
  belongs_to :user
end
