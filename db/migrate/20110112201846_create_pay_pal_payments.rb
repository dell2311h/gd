class CreatePayPalPayments < ActiveRecord::Migration
  def self.up
    create_table :pay_pal_payments do |t|
      t.belongs_to  :user
      t.string    :description
      t.string    :payment_type
      t.string    :related_id
      t.string    :token
      t.string    :date
      t.string    :total
      t.string    :customer_name
      t.string    :customer_id
      t.string    :customer_address
      t.string    :customer_email
      t.string    :customer_phone
      t.string    :customer_hash
      t.timestamps
    end
  end

  def self.down
    drop_table :pay_pal_payments
  end
end
