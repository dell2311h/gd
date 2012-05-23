# == Schema Information
# Schema version: 20110213115125
#
# Table name: countries
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(50)      not null
#  fips104              :string(2)       not null
#  iso2                 :string(2)       not null
#  iso3                 :string(3)       not null
#  ison                 :string(4)       not null
#  internet             :string(2)       not null
#  capital              :string(25)
#  map_reference        :string(50)
#  nationality_singular :string(35)
#  nationaiity_plural   :string(35)
#  currency             :string(30)
#  currency_code        :string(3)
#  population           :integer(4)
#  title                :string(50)
#  comment              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  delta                :boolean(1)      default(TRUE)
#

class Country < ActiveRecord::Base
    has_many :regions

    define_index do
      indexes :name, :sortable => true
    end

end
