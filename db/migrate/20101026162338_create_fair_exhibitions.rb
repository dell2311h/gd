class CreateFairExhibitions < ActiveRecord::Migration
  def self.up
    create_table :fair_exhibitions do |t|
      t.belongs_to  :fair
      t.belongs_to  :exhibition
      t.belongs_to  :venue
      t.boolean     :paid, :default => false
      t.string      :transaction_id
      t.date        :transaction_date
      t.string      :transaction_cost
      t.string      :description
      t.timestamps
    end
  end

  def self.down
    drop_table :fair_exhibitions
  end
end
