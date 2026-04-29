require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get quotes_path

    assert_response :success
  end

  test "should show quote" do
    quote = Quote.create!(name: "Devis client")

    get quote_path(quote)

    assert_response :success
  end

  test "should create quote" do
    assert_difference "Quote.count", 1 do
      post quotes_path, params: { quote: { name: "Devis client" } }
    end

    assert_redirected_to quote_path(Quote.last)
  end

  test "should update draft quote" do
    quote = Quote.create!(name: "Devis client")

    patch quote_path(quote), params: { quote: { name: "Nouveau nom" } }

    assert_redirected_to quote_path(quote)
    assert_equal "Nouveau nom", quote.reload.name
  end

  test "should validate quote" do
    quote = Quote.create!(name: "Devis client")

    patch validate_quote_path(quote)

    assert_redirected_to quote_path(quote)
    assert_predicate quote.reload, :validated?
    assert_not_nil quote.validated_at
  end

  test "should not update validated quote" do
    quote = Quote.create!(name: "Devis client")
    quote.mark_as_validated!

    patch quote_path(quote), params: { quote: { name: "Nouveau nom" } }

    assert_redirected_to quote_path(quote)
    assert_equal "Devis client", quote.reload.name
  end

  test "should destroy draft quote" do
    quote = Quote.create!(name: "Devis client")

    assert_difference "Quote.count", -1 do
      delete quote_path(quote)
    end

    assert_redirected_to quotes_path
  end

  test "should not destroy validated quote" do
    quote = Quote.create!(name: "Devis client")
    quote.mark_as_validated!

    assert_no_difference "Quote.count" do
      delete quote_path(quote)
    end

    assert_redirected_to quote_path(quote)
  end
end
