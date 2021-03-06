require "rails_helper"

RSpec.describe "Dashboard" do
  it "has navigation links" do
    user = create(:admin)
    sign_in(user)
    visit(dashboard_root_path)

    within("#top_nav") do
      expect(page).to have_link(
        I18n.translate!(:"titles.accounts.edit"),
        href: edit_dashboard_account_path
      )
    end

    within("#side_navigation") do
      expect(page).to have_link(
        I18n.translate!(:"titles.access_tokens.index"),
        href: dashboard_access_tokens_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.batch_operations.index"),
        href: dashboard_batch_operations_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.callouts.new"),
        href: new_dashboard_callout_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.callouts.index"),
        href: dashboard_callouts_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.callout_participations.index"),
        href: dashboard_callout_participations_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.contacts.index"),
        href: dashboard_contacts_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.phone_calls.index"),
        href: dashboard_phone_calls_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.remote_phone_call_events.index"),
        href: dashboard_remote_phone_call_events_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.sensors.index"),
        href: dashboard_sensors_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.sensor_events.index"),
        href: dashboard_sensor_events_path
      )

      expect(page).to have_link(
        I18n.translate!(:"titles.users.index"),
        href: dashboard_users_path
      )
    end
  end
end
