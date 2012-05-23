# == Schema Information
# Schema version: 20110213115125
#
# Table name: fair_exhibitions
#
#  id                     :integer(4)      not null, primary key
#  fair_id                :integer(4)
#  exhibition_id          :integer(4)
#  venue_id               :integer(4)
#  paid                   :boolean(1)      default(FALSE)
#  description            :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  delta                  :boolean(1)      default(TRUE)
#  pp_ex_token            :string(255)
#  pp_ex_date             :datetime
#  pp_ex_total            :string(255)
#  pp_ex_customer_name    :string(255)
#  pp_ex_customer_id      :string(255)
#  pp_ex_customer_address :string(255)
#  pp_ex_customer_email   :string(255)
#  pp_ex_customer_phone   :string(255)
#  pp_ex_customer_hash    :text
#  invitation_email_sent  :boolean(1)      default(FALSE)
#

class FairExhibition < ActiveRecord::Base
  belongs_to  :fair
  belongs_to  :exhibition
  belongs_to  :venue
  has_many    :fair_attachments
  
  define_index do
    indexes fair.name, :as => :fair_name, :sortable => true
    indexes venue.name, :as => :venue_name, :sortable => true
    indexes [exhibition.artists(:firstname), exhibition.artists(:lastname)], :as => :artist
    indexes exhibition.title, :as => :exhibition_name, :sortable => true
    # neighborhood, city or state
    indexes fair.neighbourhood.name, :as => :neighborhood, :sortable => true
    indexes fair.city.name, :as => :city, :sortable => true
    indexes fair.region.name, :as => :region, :sortable => true
    indexes fair.city.region_grouping.keywords, :as => :region_grouping_keywords, :sortable => false    
    
    has :fair_id
    has :exhibition_id
    has :venue_id
    has :paid
    has fair(:fair_grouping_id), :as => :fair_grouping_id
    has :updated_at
    has "ASCII(SUBSTRING(UCASE(`venues`.`name`),1,1))", :as => :venue_first_letter, :type => :integer
    
    set_property :delta => true
    set_property :min_infix_len => 1
    set_property :group_concat_max_len => 8192
  end
  
  attr_protected :paid
  
end
