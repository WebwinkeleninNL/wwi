class Merchant < ActiveRecord::Base
  has_many :users

  validates :url, :name, :description, presence: true
end