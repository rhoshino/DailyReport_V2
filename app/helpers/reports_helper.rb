module ReportsHelper
  def send_report(user,report)
    @user = user
    @report = report

    if report.public_flag? && @user.sendto_address != []
      @mail = ReportMail.report_submitted(user,report).deliver
    end
  end
end
