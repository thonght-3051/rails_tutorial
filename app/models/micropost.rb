class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :content, presence: true,
    length: {maximum: Settings.const.content_micropost}
  validates :image, content_type: {
                      in: Settings.const.image_format,
                      message: I18n.t("micropost.validate.image.content_type")
                    },
                    size: {
                      less_than: Settings.const.image_size.megabytes,
                      message: I18n.t("micropost.validate.image.size")
                    }
  scope :newest, ->{order created_at: :desc}
  scope :relate_post, ->(user_ids){where user_id: user_ids}
  REQUEST_VARIABLE = [:content, :image]

  def display_image
    image.variant resize_to_limit: Settings.const.resign_image
  end
end
