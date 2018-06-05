class Dashboard::UsersController < Dashboard::BaseController
  before_action :authorize_admin!, except: :update
  before_action :authorize_owner_or_admin!, only: :update

  private

  def association_chain
    current_account.users
  end

  def permitted_params
    params.require(:user).permit(:roles, :locale, location_ids: [])
  end

  def resources_path
    dashboard_users_path
  end

  def show_location(resource)
    dashboard_user_path(resource)
  end

  def respond_with_updated_resource
    if resource.previous_changes["locale"]
      redirect_back(fallback_location: root_path)
    else
      super
    end
  end

  def authorize_owner_or_admin!
    (resource == current_user) || authorize_admin!
  end
end
