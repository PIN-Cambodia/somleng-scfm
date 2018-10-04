class Api::ContactDataController < Api::BaseController
  private

  def build_resource_from_params
    @resource = current_account.contacts.where_msisdn(
      params.require(:msisdn)
    ).first_or_initialize
  end

  def prepare_resource_for_create
    resource.assign_attributes(permitted_params)
  end

  def permitted_params
    params.permit(:created_at, :metadata_merge_mode, metadata: {})
  end

  def access_token_write_permissions
    [:contacts_write]
  end
end
