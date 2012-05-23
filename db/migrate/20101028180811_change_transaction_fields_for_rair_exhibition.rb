class ChangeTransactionFieldsForRairExhibition < ActiveRecord::Migration
  def self.up
    remove_column :fair_exhibitions, :transaction_id
    remove_column :fair_exhibitions, :transaction_date
    remove_column :fair_exhibitions, :transaction_cost
    
    add_column    :fair_exhibitions, :pp_ex_token, :string
    add_column    :fair_exhibitions, :pp_ex_date, :datetime
    add_column    :fair_exhibitions, :pp_ex_total, :string
    add_column    :fair_exhibitions, :pp_ex_customer_name, :string
    add_column    :fair_exhibitions, :pp_ex_customer_id, :string
    add_column    :fair_exhibitions, :pp_ex_customer_address, :string
    add_column    :fair_exhibitions, :pp_ex_customer_email, :string
    add_column    :fair_exhibitions, :pp_ex_customer_phone, :string
    add_column    :fair_exhibitions, :pp_ex_customer_hash, :text, :default => nil
  end

  def self.down
    add_column :fair_exhibitions, :transaction_id, :string
    add_column :fair_exhibitions, :transaction_date, :date
    add_column :fair_exhibitions, :transaction_cost, :string
    
    remove_column :fair_exhibitions, :pp_ex_token
    remove_column :fair_exhibitions, :pp_ex_date
    remove_column :fair_exhibitions, :pp_ex_total
    remove_column :fair_exhibitions, :pp_ex_customer_name
    remove_column :fair_exhibitions, :pp_ex_customer_id
    remove_column :fair_exhibitions, :pp_ex_customer_address
    remove_column :fair_exhibitions, :pp_ex_customer_email
    remove_column :fair_exhibitions, :pp_ex_customer_phone
    remove_column :fair_exhibitions, :pp_ex_customer_hash
  end
end
