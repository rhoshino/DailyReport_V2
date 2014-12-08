module ApplicationHelper
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
