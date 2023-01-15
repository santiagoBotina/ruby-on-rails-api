class Post < ApplicationRecord
  belongs_to :user

  #Validates the prescence of the fields
  validates :title, :content, :user_id, presence: true
  #inclusion es usado para booleans
  validates :published, inclusion: {in: [true, false]}
end
