class User < ApplicationRecord
  include MetadataHelpers

  enum locale: %i[en km]
  store_accessor :metadata, :location_ids

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :registerable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  belongs_to :account

  bitmask :roles, as: %i[member admin], null: false

  before_validation :remove_empty_location_ids

  validates :roles, presence: true

  def is_admin?
    roles?(:admin)
  end

  private

  def remove_empty_location_ids
    self.location_ids = Array(location_ids).reject(&:blank?).presence
  end
end
