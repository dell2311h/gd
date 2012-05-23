# == Schema Information
# Schema version: 20110213115125
#
# Table name: pay_pal_payments
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  description      :string(255)
#  payment_type     :string(255)
#  related_id       :string(255)
#  token            :string(255)
#  date             :string(255)
#  total            :string(255)
#  customer_name    :string(255)
#  customer_id      :string(255)
#  customer_address :string(255)
#  customer_email   :string(255)
#  customer_phone   :string(255)
#  customer_hash    :text
#  created_at       :datetime
#  updated_at       :datetime
#

class PayPalPayment < ActiveRecord::Base
  belongs_to  :venue, :foreign_key => 'user_id'
end
