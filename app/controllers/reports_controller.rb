class ReportsController < ApplicationController
  before_action :authenticate_user!

  before_action :correct_or_admin_user,only: [:destroy,:edit,:show]

  before_action :admin_user,only:[:admin_reports_list]

  def new
    @report = Report.new()
  end

  def user_reports
    @reports = current_user.reports
  end

  def public_user_reports
    @reports = current_user.public_reports
  end

  def draft_user_reports
    @reports = current_user.draft_reports
  end

  def admin_reports_list
    if params[:fillterd]
      if params[:user].present?
        user_name = params[:user].to_s
      end
      if params[:year].present?
            year = params[:year].to_s
      end
      if params[:month].present?
            month = params[:month].to_s
      end
      if params[:public_flag].present?
            public_flag = true
      end
    else
      params[:user] = nil
      params[:year] = nil
      params[:month] = nil
      params[:public_flag] = nil
    end

    @report = fillterd_report_generator(user_name,year,month,public_flag)

  end

  def month_report #月報
    unless params[:year].present?
      params[:year] = Date.today.year
    end
    unless params[:month].present?
      params[:month] = Date.today.month
    end
    @worktime = month_report_worktime_calculator(current_user)
    @report = month_report_generator(current_user,params[:year],params[:month])

  end


  def create
    @report = current_user.reports.build(reports_params)

    if @report.save
      respond_to do |format|
#binding.pry
        ApplicationController.helpers.send_report(@report.user,@report)
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      end
    end
  end

  def edit
   @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(reports_params)
 # binding.pry
        ApplicationController.helpers.send_report(@report.user,@report)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy
    redirect_to root_url
  end

  def show
    @report = Report.find(params[:id])
  end

  def correct_user
    @report = current_user.reports.find_by(id: params[:id])
    redirect_to root_url if @report.nil?
  end


  private
    def reports_params
      params.require(:report).permit(:title,
                                      :body_text,
                                      :user_id,
                                      :reported_date,
                                      :work_start_time,
                                      :work_end_time,
                                      :public_flag)
    end

    def correct_or_admin_user
      # binding.pry
      unless current_user.admin?
        @report = current_user.reports.find_by(id: params[:id])
        redirect_to root_url if @report.nil?
      end
    end


    def admin_user
      redirect_to(root_url) unless current_user.admin?
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
      hours = 0
      mins = 0
      # reports = @reports
      #まず開始時間と終了時間のリストを作成する。
      reports.each do |report|
        # day1 = Time.local(2000, 12, 31, 0, 0, 0) #=> Sun Dec 31 00:00:00 JST 2000
        # day2 = Time.local(2001, 1, 2, 12, 30, 0) #=> Tue Jan 02 12:30:00 JST 2001
        starttime = report.work_start_time
        endtime = report.work_end_time
        days = (endtime - starttime).divmod(24*60*60) #=> [2.0, 45000.0]
        hours = days[1].divmod(60*60) #=> [12.0, 1800.0]
        mins = hours[1].divmod(60) #=> [30.0, 0.0]

      end

      return {:hour => hours[0], :minute => mins[0]}

    end#def calc_month_work_time

    #def month_report_generator(user,month)
    def month_report_generator(user,year,month)
      @reports = Report.where(user_id: user, public_flag: true)
      @reports = @reports.where('extract(year from reported_date) = ?', year)
      @reports = @reports.where('extract(month from reported_date) = ?', month)
      @reports #return
    end

    def fillterd_report_generator(user,year,month,public_flag)
      @reports = Report.all
      unless user.nil?
        @reports = @reports.where(user_id: user)
      end
      unless year.nil?
        @reports = @reports.where('extract(year from reported_date) = ?', year)
      end
      unless month.nil?
        @reports = @reports.where('extract(month from reported_date) = ?', month)
      end
      unless public_flag.nil?
        @reports = @reports.where(public_flag: true)
      end
    end


end