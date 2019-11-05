class CreateOnDemands < ActiveRecord::Migration[5.2]
  def change
    create_table :prices do |t|
      t.string :sku
      t.string :region
      t.timestamp :effective_date

      t.timestamps
    end
  end
end
