require "rails_helper"

RSpec.describe "Landing Page" do
  it "has navigation links" do
    visit(root_path)

    within("#top_nav") do
      expect(page).to have_link("Sensor Map", href: root_path)
      expect(page).to have_link("About Us", href: about_path)
      expect(page).to have_link("Contact", href: contact_path)
      expect(page).to have_link("How to registration?", href: registration_path)
      expect(page).to have_link("Login", href: new_user_session_path)
    end
  end

  it "has dashboard links when user signed in" do
    user = create(:user)
    sign_in(user)
    visit(root_path)

    within("#top_nav") do
      expect(page).to have_link("Dashboard", href: dashboard_root_path)
    end
  end
end
