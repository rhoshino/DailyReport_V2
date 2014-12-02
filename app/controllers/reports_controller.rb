class ReportsController < ApplicationController

  before_action :authenticate_user!

  before_action :correct_user,only: :destroy

  def new
    @report = Report.new()
  end

  def user_reports
    @reports = current_user.reports
  end

  def public_user_reports
    @reports = current_user.public_reports
  end

  def month_report
    params[:month] ||= Date.today.month
    @reports = month_report_generator(current_user,params[:month])
  end

  def create
    @report = current_user.reports.build(reports_params)

    if @report.save
      respond_to do |format|
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


  private
    def reports_params
      params.require(:report).permit(:title,
                                      :body_text,
                                      :user_id,
                                      :reported_date,
                                      :public_flag)
    end

    def correct_user
      @report = current_user.reports.find_by(id: params[:id])
      redirect_to root_url if @report.nil?
    end

    def month_report_generator(user,month)
      # @reports =  Report.where(user_id: user)
      @reports = Report.where(user_id: user)

      @reports = @reports.where('extract(month from reported_date) = ?', month)
      @reports
    end

end