class ItemsController < ApplicationController
  before_action :set_quote
  before_action :ensure_quote_is_editable
  before_action :set_item, only: %i[edit update destroy]

  def create
    @item = @quote.items.build(item_params)

    if @item.save
      redirect_to quote_path(@quote), notice: "Article ajouté avec succès"
    else
      render "quotes/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to quote_path(@quote), notice: "Article mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to quote_path(@quote), notice: "Article supprimé avec succès"
  end

  private

  def set_quote
    @quote = Quote.includes(:items).find(params[:quote_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to quotes_path, alert: "Devis non trouvé"
  end

  def set_item
    @item = @quote.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :unit_price_cents, :vat_rate)
  end
end
