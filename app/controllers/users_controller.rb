class UsersController < ApplicationController

  before_action :authenticate_user!

  def home
    @user = current_user
    @reports = current_user.reports
  end


  def show
  end
  def reports_params
    params.require(:report).permit(:title,
                                    :body_text,
                                    :user_id,
                                    :reported_date,
                                    :public_flag)
  end
end
