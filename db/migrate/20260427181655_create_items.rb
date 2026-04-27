class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.references :quote, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :quantity, null: false
      t.integer :unit_price_cents, null: false
      t.decimal :vat_rate, null: false, precision: 5, scale: 2

      t.timestamps
    end
  end
end
