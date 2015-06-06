class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  # associates image with a model via CarrierWave
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140} 
  # validate = custom validation
  validate :picture_size
  
  private
  
    # validates size of uploaded picture
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "File size should be less than 5MB")
      end
    end
end
