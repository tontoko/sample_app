class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # order('created_at DESC') SQL文
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
