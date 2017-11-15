class CreatePhoneCalls < ApplicationMigration
  def change
    create_table :phone_calls do |t|
      t.references(:callout_participation, :index => true, :foreign_key => true)
      t.references(:contact, :null => false, :index => true, :foreign_key => true)
      t.references(:create_batch_operation, :index => true, :foreign_key => true)
      t.references(:queue_batch_operation, :index => true, :foreign_key => true)
      t.references(:queue_remote_fetch_batch_operation, :index => true, :foreign_key => true)
      t.string(:status, :null => false)
      t.string(:msisdn, :null => false)
      t.string(:remote_call_id, :index => {:unique => true})
      t.string(:remote_status)
      t.string(:remote_direction)
      t.text(:remote_error_message)
      t.public_send(json_column_type, :metadata, :null => false, :default => json_column_default)
      t.public_send(json_column_type, :remote_response, :null => false, :default => json_column_default)
      t.public_send(json_column_type, :remote_request_params, :null => false, :default => json_column_default)
      t.public_send(json_column_type, :remote_queue_response, :null => false, :default => json_column_default)
      t.datetime "remotely_queued_at"
      t.timestamps
    end
  end
end
