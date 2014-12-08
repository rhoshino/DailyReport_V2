#coding:utf-8
class User < ActiveRecord::Base

  has_many :reports, dependent: :destroy

  validates :name,presence: true,
                  length: {maximum: 50}

  before_save { self.email = email.downcase }

  serialize :sendto_address, Array
  validate :sendto_address_is_collect_format_or_null
  #teno_textはデータベースに登録しない。送付先メールアドレスの一時受け
  attr_accessor :temp_address

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #データベースに登録前、送信先アドレスを加工する
  before_save :saved_send_address


  def admin?
    self.role == "admin"
  end

  def public_reports
    Report.where(user_id: self.id, public_flag: true)
  end

  def public_reports_count
    @reports = public_reports.count
  end

  def draft_reports
    Report.where(user_id: self.id, public_flag: false)
  end

  def draft_reports_count
    @reports = draft_reports.count
  end

  #送信先アドレスの加工と保存(※バリデーション済み)
  def saved_send_address

    #各要素ずつpush
    unless temp_address == nil
      #debugger
      #配列の初期化
      sendto_address.clear
      temp_address.each_line do |line|
          sendto_address.push line.strip
      end
    end
    #temp_text.clear
  end


  def sendto_address_is_collect_format_or_null
    reg = /^([a-z0-9\+_\-]+)(\.[a-z0-9\+_\-]+)*@([a-z0-9\-]+\.)+[a-z]{2,6}$/

    unless temp_address.blank?#空欄はチャック対象外

      #テキストエリアの内容を取得して改行で区切る
      address_array = Array.new()
      temp_address.each_line do |line|
        address_array.push line.strip
      end
      #debugger
      #分割した要素ずつ正しいアドレスの形をしているかチェックする。
      #配列の形でmodelが格納していれば、この処理難度も書かなくていいのでは。
      address_array.each do |s|
        #debugger
        unless reg === s
          self.errors[:base] << "正しくないフォーマットで書かれています。(空欄可) #{s}"
        end
      end
    end
  end# def semdto_address_is_collect_fomat_or_null

end
