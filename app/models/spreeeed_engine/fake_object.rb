module SpreeeedEngine
  class FakeObject < ApplicationRecord
    validates :name, presence: true
    validates :name, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }

    validates :email, presence: true
    validates :email, uniqueness: true

    validates :password, length: { in: 6..12 }

    validates :credit, numericality: true

    validates :amount, numericality: { only_integer: true }

    # has_many :photos, class_name: 'SpreeeedEngine::FakePhoto', foreign_key: 'owner_id'
    # accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true

    has_one :avatar, -> { where(label: 'Avatar') }, class_name: 'SpreeeedEngine::FakePhoto', foreign_key: 'owner_id'
    accepts_nested_attributes_for :avatar, reject_if: :all_blank, allow_destroy: true
  end
end
