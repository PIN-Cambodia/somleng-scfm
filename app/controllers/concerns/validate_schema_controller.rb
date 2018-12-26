module ValidateSchemaController
  extend ActiveSupport::Concern

  included do
    class_attribute :request_schema
  end

  private

  def create_resource
    @resource = validate_schema do |permitted_params|
      create_resource!(permitted_params)
    end
  end

  def save_resource
    validate_schema do |permitted_params|
      update_resource!(permitted_params)
    end
  end

  def validate_schema(&_block)
    schema_validation_result = request_schema.with(
      resource: resource, account: current_account, action: action_name
    ).call(permitted_schema_params)

    if schema_validation_result.success?
      yield(schema_validation_result.output)
    else
      build_errors(schema_validation_result)
    end
  end

  def build_errors(schema_validation_result)
    schema_validation_result.errors.each do |field, messages|
      resource.errors.add(field, messages.first)
    end

    resource
  end

  def permitted_schema_params
    permitted_params.to_h
  end

  def create_resource!(permitted_params)
    resource = build_resource_association_chain.new(permitted_params)
    save_resource!(resource)
  end

  def update_resource!(permitted_params)
    resource.attributes = permitted_params
    save_resource!(resource)
  end

  def save_resource!(resource)
    resource.save!
    resource
  end
end
