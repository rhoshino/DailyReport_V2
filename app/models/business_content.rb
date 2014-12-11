class BusinessContent < ActiveRecord::Base

  belongs_to :report;

  validates :report_id, presence: true
end
