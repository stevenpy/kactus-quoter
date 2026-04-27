class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.string :name, null: false
      t.integer :status, null: false, default: 0
      t.datetime :validated_at

      t.timestamps
    end
  end
end
