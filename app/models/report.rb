class Report < ActiveRecord::Base
  belongs_to :user;

  validates :user_id, presence: true
  validates :title, presence: true
  validates :body_text, presence: true
  validates :reported_date, presence: true

  def public_flag?
      public_flag == true
  end

end
