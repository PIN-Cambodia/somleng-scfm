require "rails_helper"

RSpec.describe "Contacts", :aggregate_failures do
  it "can list all contacts" do
    user = create(:admin)
    contact = create(:contact, account: user.account)
    other_contact = create(:contact)

    sign_in(user)
    visit dashboard_contacts_path

    expect(page).to have_title("Contacts")

    within("#page_actions") do
      expect(page).to have_link_to_action(
        :new, key: :contacts, href: new_dashboard_contact_path
      )
    end

    within("#resources") do
      expect(page).to have_content_tag_for(contact)
      expect(page).not_to have_content_tag_for(other_contact)
      expect(page).to have_content("#")
      expect(page).to have_link(
        contact.id,
        href: dashboard_contact_path(contact)
      )

      expect(page).to have_sortable_column("msisdn")
      expect(page).to have_sortable_column("created_at")
    end
  end

  it "can create a new contact", :js do
    user = create(:admin)
    phone_number = generate(:somali_msisdn)

    sign_in(user)
    visit new_dashboard_contact_path

    expect(page).to have_title("New Contact")

    click_action_button(:create, key: :submit, namespace: :helpers, model: "Contact")

    expect(page).to have_content("Phone number must be filled")

    fill_in_contact_information(phone_number)
    fill_in_key_value_for(
      :metadata,
      with: { key: "gender", value: "f" },
      index: 0
    )

    click_action_button(:create, key: :submit, namespace: :helpers, model: "Contact")

    expect(page).to have_text("Contact was successfully created.")
    new_contact = user.reload.account.contacts.last!
    expect(new_contact.msisdn).to match(phone_number)
    expect(new_contact.metadata.fetch("gender")).to eq("f")
  end

  it "can update a contact", :js do
    user = create(:admin)
    contact = create(
      :contact,
      account: user.account,
      metadata: {
        "foo" => "bar",
        "commune_ids" => %w[
          120101 120102
        ]
      }
    )

    sign_in(user)
    visit edit_dashboard_contact_path(contact)

    expect(page).to have_title("Edit Contact")

    updated_phone_number = generate(:somali_msisdn)

    fill_in_contact_information(updated_phone_number)
    remove_key_value_for(:metadata, index: 0)
    add_key_value_for(:metadata)
    fill_in_key_value_for(
      :metadata,
      with: { key: "gender", value: "f" },
      index: 1
    )
    add_key_value_for(:metadata)
    fill_in_key_value_for(
      :metadata,
      with: { key: "address:country_code", value: "kh" },
      index: 2
    )

    click_action_button(:update, key: :submit, namespace: :helpers)

    expect(page).to have_current_path(dashboard_contact_path(contact))
    expect(page).to have_text("Contact was successfully updated.")
    contact = contact.reload
    expect(contact.msisdn).to match(updated_phone_number)
    expect(contact.metadata.fetch("gender")).to eq("f")
    expect(contact.metadata.fetch("address").fetch("country_code")).to eq("kh")
    expect(contact.metadata.fetch("commune_ids")).to match_array(%w[120101 120102])
  end

  it "can delete a contact" do
    user = create(:admin)
    contact = create(:contact, account: user.account)

    sign_in(user)
    visit dashboard_contact_path(contact)

    click_action_button(:delete, type: :link)

    expect(current_path).to eq(dashboard_contacts_path)
    expect(page).to have_text("Contact was successfully destroyed.")
  end

  it "can show a contact" do
    user = create(:admin)
    phone_number = generate(:somali_msisdn)
    contact = create(
      :contact,
      account: user.account,
      msisdn: phone_number,
      metadata: {
        "gender" => "female"
      }
    )

    sign_in(user)
    visit dashboard_contact_path(contact)

    expect(page).to have_title("Contact #{contact.id}")

    within("#page_actions") do
      expect(page).to have_link_to_action(
        :edit,
        href: edit_dashboard_contact_path(contact)
      )
    end

    within("#related_links") do
      expect(page).to have_link_to_action(
        :index,
        key: :callout_participations,
        href: dashboard_contact_callout_participations_path(contact)
      )

      expect(page).to have_link_to_action(
        :index,
        key: :phone_calls,
        href: dashboard_contact_phone_calls_path(contact)
      )
    end

    within("#contact") do
      expect(page).to have_content(contact.id)
      expect(page).to have_content("#")
      expect(page).to have_content("Phone number")
      expect(page).to have_content(phone_number)
      expect(page).to have_content("Metadata")
      expect(page).to have_content("gender")
      expect(page).to have_content("female")
    end
  end

  def fill_in_contact_information(phone_number)
    fill_in("Phone number", with: phone_number)
  end
end
