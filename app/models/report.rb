class Report < ActiveRecord::Base
  belongs_to :user
  #has_many :business_contents

  validates :user_id, presence: true
  validates :title, presence: true

  validates :reported_date, presence: true


  validates :body_text, presence: true,if: [ :public_flag?, :rest_is_nil? ]

  validates :work_start_time, presence: true, if: [ :public_flag?, :rest_is_nil? ]
  validates :work_end_time, presence: true, if: [ :public_flag?, :rest_is_nil? ]


  #validate :report_costom_validate

  def public_flag?
    public_flag == true
  end

  def rest_is_nil?
    rest == nil
  end

  # def rest_is?
  #   rest == nil
  # end
  def report_costom_validate

    if public_flag?
      if rest == "all" || rest == "harf"


      else

        #rest == nil
      end
    else
      #public_flag? == false
    end
  end# def report_costom_validate

end
