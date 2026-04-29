class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy validate]
  before_action :ensure_quote_is_editable, only: %i[edit update destroy]

  def index
    @quotes = Quote.recent_first
    @quote = Quote.new
  end

  def show
    @items = @quote.items.order(created_at: :asc)
    @item = Item.new(quote: @quote)
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to quote_path(@quote), notice: "Devis crée avec succès"
    else
      @quotes = Quote.recent_first
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to quote_path(@quote), notice: "Devis mis à jour avec succès" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy
    redirect_to quotes_path, notice: "Devis supprimé avec succès"
  end

  def validate
    if @quote.validated?
      redirect_to quote_path(@quote), notice: "Le devis a déjà été validé"
      return
    end

    @quote.mark_as_validated!
    redirect_to quote_path(@quote), notice: "Devis validé avec succès"
  end

  private

  def set_quote
    @quote = Quote.includes(:items).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to quotes_path, alert: "Devis non trouvé"
  end

  def quote_params
    params.require(:quote).permit(:name)
  end
end
