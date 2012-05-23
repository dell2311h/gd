# == Schema Information
# Schema version: 20110213115125
#
# Table name: media_service_setups
#
#  id                  :integer(4)      not null, primary key
#  venue_id            :integer(4)
#  media_service_id    :integer(4)
#  media_site_login    :string(255)
#  media_site_password :string(255)
#

class MediaServiceSetup < ActiveRecord::Base
  belongs_to  :venue
  belongs_to  :media_service
  validates_presence_of :media_site_login, :if => Proc.new {|s| s.media_service.form_based? }
  validates_presence_of :media_site_password, :if => Proc.new {|s| s.media_service.form_based? }
end
