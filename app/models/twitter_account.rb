class TwitterAccount < ActiveRecord::Base
  has_one :user
  has_one :circle

  validates :uid, presence: true
  validates :screen_name, presence: true

  def registered?
    self.user.present? || self.circle.present?
  end

  def admin?
    %w(ikstrm chi08ka sophimet).include?(screen_name)
  end
end
