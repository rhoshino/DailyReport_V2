class Report < ActiveRecord::Base
  belongs_to :user
  #has_many :business_contents

  validates :user_id, presence: true
  validates :title, presence: true
  validates :body_text, presence: true
  validates :reported_date, presence: true
  validates :work_start_time, presence: true
  validates :work_end_time, presence: true

  def public_flag?
      public_flag == true
  end

end
