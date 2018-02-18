class Api::AuthenticatedController < Api::BaseController
  before_action :doorkeeper_authorize!

  private

  def current_account
    @current_account ||= Account.find(doorkeeper_token && doorkeeper_token.resource_owner_id)
  end

  def authorize_super_admin!
    deny_access! if !current_account.super_admin?
  end

  def deny_access!
    head(:unauthorized)
  end

  def specified_or_current_account
    current_account.super_admin? && params[:account_id] && Account.find(params[:account_id]) || current_account
  end
end
