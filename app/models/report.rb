class Report < ActiveRecord::Base
  belongs_to :user;

  validates :user_id, presence: true
  validates :title, presence: true
  validates :body_text, presence: true

end
