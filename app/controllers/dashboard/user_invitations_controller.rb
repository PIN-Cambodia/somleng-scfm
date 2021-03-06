module Dashboard
  class UserInvitationsController < Devise::InvitationsController
    before_action :authorize_admin!, only: :new

    protected

    def invite_params
      super.merge(account_id: current_inviter.account_id)
    end

    def after_invite_path_for(_inviter, _invitee = nil)
      dashboard_users_path
    end
  end
end
