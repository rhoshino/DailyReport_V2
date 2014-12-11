module ReportsHelper
  def send_report(user,report)
    @user = user
    @report = report

    if report.public_flag? && @user.sendto_address != []
      @mail = ReportMail.report_submitted(user,report).deliver
    end
  end

  def month_report_worktime_calculator(user)
    year = Date.today.year
    month = Date.today.month
    @reports = Report.where(user_id: user, public_flag: true)
    @reports = @reports.where('extract(year from reported_date) = ?', year)
    @reports = @reports.where('extract(month from reported_date) = ?', month)
    work_time = calc_month_work_time(@reports)
    return work_time
  end

  def calc_month_work_time(reports)
    sum_diff_time = 0
    # reports = @reports
    #まず開始時間と終了時間のリストを作成する。
    reports.each do |report|

      starttime = report.work_start_time
      endtime = report.work_end_time

      sum_diff_time += endtime - starttime# this is second
    end

    diff_time_hour = sum_diff_time.divmod(60*60)
    diff_time_min = diff_time_hour[1].divmod(60)
    # binding.pry
    # return {:hour => hours[0], :minute => mins[0]}
    return{:hour => diff_time_hour[0], :minute => diff_time_min[0]}

  end#def calc_month_work_time


end
