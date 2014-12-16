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
      if params[:serch_text].present?
        serch_text = params[:serch_text].to_s
      end
    else
      params[:user] = nil
      params[:year] = nil
      params[:month] = nil
      params[:public_flag] = nil
      params[:serch_text] = nil
    end

    @report = fillterd_report_generator(user_name,year,month,public_flag, serch_text)

  end

  def month_report #月報
    unless params[:year].present?
      params[:year] = Date.today.year
    end
    unless params[:month].present?
      params[:month] = Date.today.month
    end
    @worktime = ApplicationController.helpers.month_report_worktime_calculator(current_user)
    # @resttime = ApplicationController.helpers.month_report_resttime_calculator(current_user)

    @reports = month_report_generator(current_user,params[:year],params[:month])

  end


  def create
    @report = current_user.reports.build(reports_params)

    if @report.save

      respond_to do |format|

        ApplicationController.helpers.send_report(@report.user,@report)

        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      end
    else
    render 'new'
    end

  end

  def edit
   @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(reports_params)

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
    @report = Report.find(params[:id])
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
                                      :rest,
                                      :public_flag)
    end

    # def business_contents_params
    #   params.require(:business_content).permit(:report_id,
    #                                             :content_name)
    # end

    def correct_or_admin_user

      unless current_user.admin?
        @report = current_user.reports.find_by(id: params[:id])
        redirect_to root_url if @report.nil?
      end
    end


    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    #def month_report_generator(user,month)
    def month_report_generator(user,year,month)
      @reports = Report.where(user_id: user, public_flag: true)
      @reports = @reports.where('extract(year from reported_date) = ?', year)
      @reports = @reports.where('extract(month from reported_date) = ?', month)
      @reports #return
    end

    def fillterd_report_generator(user,year,month,public_flag,serch_text)
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
      unless serch_text.nil?
        @reports = @reports.where(['body_text LIKE ?', "%#{serch_text}%"])
      end

    end


end