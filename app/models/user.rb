class User < ActiveRecord::Base

  has_many :reports, dependent: :destroy

  validates :name,presence: true,
                  length: {maximum: 50}

  before_save { self.email = email.downcase }


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  def public_reports
    # Report.find_by(user_id: self.id, public_flag: true)
    Report.where(user_id: self.id, public_flag: true)
  end

  def public_reports_count
    @reports = public_reports.count
# binding.pry

  end

end
