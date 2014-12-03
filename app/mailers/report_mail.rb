#coding:utf-8
class ReportMail < ActionMailer::Base
    default from: "from@example.com"

    def report_submitted(user,report)
      @user = user
      @report = report

      mail :to => user.sendto_address,
           :subject => "#{user.name}さんの日報が提出されました"
    end
end