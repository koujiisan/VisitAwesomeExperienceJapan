class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_one :profile
  accepts_nested_attributes_for :profile
  has_many :experiences
  has_many :comments
  has_many :likes
  has_many :liked_experiences, through: :likes, source: :experience
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }

  def likes?(experience)
    likes.exists?(experience_id: experience.id)
  end
end
