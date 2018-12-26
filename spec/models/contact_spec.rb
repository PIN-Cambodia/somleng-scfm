require "rails_helper"

RSpec.describe Contact do
  let(:factory) { :contact }

  describe "validations" do
    it { is_expected.to validate_presence_of(:msisdn) }
    it { is_expected.to allow_value(generate(:somali_msisdn)).for(:msisdn) }
    it { is_expected.not_to allow_value("252123456").for(:msisdn) }
    it { is_expected.to allow_value("+252 66-(2)-345-678").for(:msisdn) }
  end

  describe "associations" do
    it { is_expected.to have_many(:callout_participations).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:phone_calls).dependent(:restrict_with_error) }
  end

  describe "delegations" do
    it { is_expected.to delegate_method(:call_flow_logic).to(:account) }
  end

  describe "validations" do
    it "normalizes the commune ids" do
      contact = build_stubbed(:contact)
      contact.metadata["commune_ids"] = %w[120101 120102]

      contact.valid?

      expect(contact.metadata.fetch("commune_ids")).to match_array(%w[120101 120102])

      contact.metadata["commune_ids"] = "120101  120102"

      contact.valid?

      expect(contact.metadata.fetch("commune_ids")).to match_array(%w[120101 120102])
    end
  end
end
