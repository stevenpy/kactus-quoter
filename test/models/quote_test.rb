require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  test "is valid with a name" do
    quote = Quote.new(name: "Devis client")

    assert quote.valid?
  end

  test "requires a name" do
    quote = Quote.new(name: nil)

    assert_not quote.valid?
    assert_includes quote.errors[:name], "can't be blank"
  end

  test "calculates totals from items" do
    quote = Quote.create!(name: "Devis client")
    quote.items.create!(name: "Design", quantity: 2, unit_price_cents: 10_000, vat_rate: 20)
    quote.items.create!(name: "Development", quantity: 1, unit_price_cents: 15_000, vat_rate: 10)

    assert_equal 35_000, quote.total_excl_vat_cents
    assert_equal 5_500, quote.total_vat_cents
    assert_equal 40_500, quote.total_incl_vat_cents
  end

  test "mark_as_validated updates status and validation timestamp" do
    quote = Quote.create!(name: "Devis client")

    quote.mark_as_validated!

    assert_predicate quote, :validated?
    assert_not_nil quote.validated_at
  end

  test "validated quote cannot change name" do
    quote = Quote.create!(name: "Devis client")
    quote.mark_as_validated!

    quote.name = "Nouveau nom"

    assert_not quote.save
    assert_includes quote.errors[:base], "Devis non modifiable car déjà validé"
  end

  test "validated quote cannot go back to draft" do
    quote = Quote.create!(name: "Devis client")
    quote.mark_as_validated!

    quote.status = :draft

    assert_not quote.save
    assert_includes quote.errors[:base], "Devis non modifiable car déjà validé"
    assert_predicate quote.reload, :validated?
  end

  test "validated quote cannot be destroyed" do
    quote = Quote.create!(name: "Devis client")
    quote.mark_as_validated!

    assert_no_difference "Quote.count" do
      assert_not quote.destroy
    end
    assert_includes quote.errors[:base], "Devis non supprimable car déjà validé"
  end
end
