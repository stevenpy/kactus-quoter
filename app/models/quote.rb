class Quote < ApplicationRecord
  enum :status, { draft: 0, validated: 1 }, default: :draft

  has_many :items, dependent: :destroy

  validates :name, presence: true

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
end
