class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def ensure_quote_is_editable
    return if @quote.editable?

    redirect_to quote_path(@quote), notice: "Devis non modifiable car déjà validé"
  end
end
