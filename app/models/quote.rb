class Quote < ApplicationRecord
  enum :status, { draft: 0, validated: 1 }, default: :draft

  has_many :items, dependent: :destroy

  validates :name, presence: true
  validate :prevent_changes_when_validated, on: :update
  before_destroy :prevent_destroy_when_validated

  scope :recent_first, -> { order(created_at: :desc) }

  def mark_as_validated!
    update!(status: :validated, validated_at: Time.current)
  end

  def editable?
    !validated?
  end

  def total_excl_vat_cents
    items.sum(&:subtotal_excl_vat_cents)
  end

  def total_vat_cents
    items.sum(&:vat_amount_cents)
  end

  def total_incl_vat_cents
    total_excl_vat_cents + total_vat_cents
  end

  private

  def prevent_changes_when_validated
    return unless status_in_database == "validated"
    return unless has_changes_to_save?

    errors.add(:base, "Devis non modifiable car déjà validé")
  end

  def prevent_destroy_when_validated
    return unless validated?

    errors.add(:base, "Devis non supprimable car déjà validé")
    throw :abort
  end
end
