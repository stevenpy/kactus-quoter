seed_quotes = [
  {
    name: "Séminaire annuel",
    status: :draft,
    items: [
      { name: "Salle plénière", quantity: 1, unit_price_cents: 120_000, vat_rate: 20 },
      { name: "Pause café", quantity: 80, unit_price_cents: 900, vat_rate: 10 },
      { name: "Déjeuner buffet", quantity: 80, unit_price_cents: 2_800, vat_rate: 10 }
    ]
  },
  {
    name: "Atelier produit",
    status: :draft,
    items: [
      { name: "Salle atelier", quantity: 1, unit_price_cents: 75_000, vat_rate: 20 },
      { name: "Matériel projection", quantity: 1, unit_price_cents: 18_000, vat_rate: 20 },
      { name: "Cocktail networking", quantity: 35, unit_price_cents: 2_200, vat_rate: 10 }
    ]
  },
  {
    name: "Réunion comité exécutif",
    status: :draft,
    items: [
      { name: "Salon privé", quantity: 1, unit_price_cents: 95_000, vat_rate: 20 },
      { name: "Petit déjeuner", quantity: 12, unit_price_cents: 1_500, vat_rate: 10 },
      { name: "Déjeuner assis", quantity: 12, unit_price_cents: 4_500, vat_rate: 10 }
    ]
  },
  {
    name: "Formation commerciale",
    status: :draft,
    items: [
      { name: "Salle de formation", quantity: 2, unit_price_cents: 45_000, vat_rate: 20 },
      { name: "Support papier", quantity: 25, unit_price_cents: 600, vat_rate: 20 },
      { name: "Boissons journée", quantity: 25, unit_price_cents: 1_000, vat_rate: 10 }
    ]
  },
  {
    name: "Lancement presse",
    status: :draft,
    items: [
      { name: "Espace événementiel", quantity: 1, unit_price_cents: 180_000, vat_rate: 20 },
      { name: "Accueil invités", quantity: 2, unit_price_cents: 25_000, vat_rate: 20 },
      { name: "Cocktail apéritif", quantity: 60, unit_price_cents: 3_000, vat_rate: 10 }
    ]
  },
  {
    name: "Soirée partenaires",
    status: :validated,
    items: [
      { name: "Privatisation lieu", quantity: 1, unit_price_cents: 250_000, vat_rate: 20 },
      { name: "Dîner cocktail", quantity: 120, unit_price_cents: 5_500, vat_rate: 10 },
      { name: "Animation musicale", quantity: 1, unit_price_cents: 80_000, vat_rate: 20 }
    ]
  },
  {
    name: "Petit déjeuner clients",
    status: :validated,
    items: [
      { name: "Salon réception", quantity: 1, unit_price_cents: 55_000, vat_rate: 20 },
      { name: "Petit déjeuner buffet", quantity: 40, unit_price_cents: 1_800, vat_rate: 10 },
      { name: "Équipe accueil", quantity: 1, unit_price_cents: 30_000, vat_rate: 20 }
    ]
  },
  {
    name: "Conférence annuelle",
    status: :validated,
    items: [
      { name: "Auditorium", quantity: 1, unit_price_cents: 300_000, vat_rate: 20 },
      { name: "Régie technique", quantity: 1, unit_price_cents: 120_000, vat_rate: 20 },
      { name: "Déjeuner participants", quantity: 200, unit_price_cents: 3_200, vat_rate: 10 }
    ]
  },
  {
    name: "Team building",
    status: :validated,
    items: [
      { name: "Espace extérieur", quantity: 1, unit_price_cents: 90_000, vat_rate: 20 },
      { name: "Activité encadrée", quantity: 45, unit_price_cents: 2_500, vat_rate: 20 },
      { name: "Goûter", quantity: 45, unit_price_cents: 1_200, vat_rate: 10 }
    ]
  },
  {
    name: "Workshop innovation",
    status: :validated,
    items: [
      { name: "Salle modulable", quantity: 1, unit_price_cents: 110_000, vat_rate: 20 },
      { name: "Facilitateur", quantity: 1, unit_price_cents: 95_000, vat_rate: 20 },
      { name: "Déjeuner plateau", quantity: 30, unit_price_cents: 2_600, vat_rate: 10 }
    ]
  }
]

seed_quotes.each do |quote_attributes|
  quote = Quote.find_or_initialize_by(name: quote_attributes[:name])

  next if quote.persisted?

  quote.save!

  quote_attributes[:items].each do |item_attributes|
    quote.items.create!(item_attributes)
  end

  quote.mark_as_validated! if quote_attributes[:status] == :validated
end

puts "Seeded #{Quote.count} quotes and #{Item.count} items."
