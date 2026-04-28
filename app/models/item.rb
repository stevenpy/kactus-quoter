class Item < ApplicationRecord
  belongs_to :quote

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :vat_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :quote_must_be_editable

  def subtotal_excl_vat_cents
    quantity * unit_price_cents
  end

  def vat_amount_cents
    ((subtotal_excl_vat_cents * vat_rate.to_d) / 100).round
  end

  def total_incl_vat_cents
    subtotal_excl_vat_cents + vat_amount_cents
  end

  private

  def quote_must_be_editable
    return if quote.editable?

    errors.add(:base, "Changement impossible sur un devis validé")
  end
end
