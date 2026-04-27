module ApplicationHelper
  def euros_from_cents(cents)
    number_to_currency(cents / 100.0, unit: "€", precision: 2)
  end
end
