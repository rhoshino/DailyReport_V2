class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_or_admin_user, only:[:show]
  before_action :admin_user, only:[:admin_users_list, :destroy]

  def home
    @user = current_user
    @reports = current_user.reports
  end

  def admin_users_list
    @users = User.all
  end

  def show
    # @user = User.find(params[:id])
    if @user.nil?
      redirect_to root_url
    end

  end

  def reports_params
    params.require(:report).permit(:title,
                                    :body_text,
                                    :user_id,
                                    :reported_date,
                                    :public_flag)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    if @user.destroy
        redirect_to root_url, notice: "User deleted."
    end
  end

  private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


    def correct_or_admin_user
      # binding.pry
      if current_user.admin? || current_user.id == params[:id].to_i
        @user = User.find(params[:id])
      # elsif current_user.id == params[:id]
        # @user = User.find(params[:id])
      else
        @user = nil
      end

    end

end
