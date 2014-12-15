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
    @reports = @reports.where('rest = ? OR rest = ? ', "all","harf")
    rest_time = calc_month_rest_time(@reports)

    # return work_time
    return {:work => work_time, :rest => rest_time}
  end
  # def month_report_resttime_calculator(user)
  #   year = Date.today.year
  #   month = Date.today.month
  #   @reports = Report.where(user_id: user, public_flag: true)
  #   @reports = Report.where(user_id: user, public_flag: true)
  #   @reports = @reports.where('extract(year from reported_date) = ?', year)
  #   @reports = @reports.where('extract(month from reported_date) = ?', month)
  #   @reports = @reports.where('rest = ? OR rest = ? ', "all","harf")
  #   rest_time = calc_month_rest_time(@reports)
  #   return rest_time
  # end


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

    # return {:hour => hours[0], :minute => mins[0]}
    return{:hour => diff_time_hour[0], :minute => diff_time_min[0]}

  end#def calc_month_work_time


  def calc_month_rest_time(reports)
    rest_time = 0
    # reports = @reports
    #まず開始時間と終了時間のリストを作成する。
    reports.each do |report|

      if report.rest == "all"
        rest_time += 8
      elsif report.rest == "harf"
        rest_time += 4
      else

      end
    end
    return rest_time
  end


end
