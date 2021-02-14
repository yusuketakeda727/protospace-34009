class Comment < ApplicationRecord

  validates :text,       null: false

  belongs_to :prototype
  belongs_to :user
end
