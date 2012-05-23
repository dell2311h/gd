# == Schema Information
# Schema version: 20110213115125
#
# Table name: events
#
#  id                         :integer(4)      not null, primary key
#  venue_id                   :integer(4)
#  exhibition_id              :integer(4)
#  title                      :string(255)
#  event_type_name            :string(255)
#  start_date                 :date
#  end_date                   :date
#  start_time                 :datetime
#  end_time                   :datetime
#  description                :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  type_description           :string(255)
#  free                       :boolean(1)      default(TRUE)
#  rsvp                       :boolean(1)      default(TRUE)
#  event_type_id              :integer(4)
#  single_day                 :boolean(1)      default(TRUE)
#  cost                       :string(255)     default("")
#  delta                      :integer(4)      default(0)
#  enabled                    :boolean(1)      default(TRUE)
#  image_file_name            :string(255)
#  image_content_type         :string(255)
#  image_file_size            :integer(4)
#  image_updated_at           :datetime
#  crop_data                  :string(255)
#  curator                    :text
#  media_contact              :text
#  associated_publication     :text
#  associated_publication_url :text
#  short_description          :text
#  listing_agent_enabled      :boolean(1)      default(FALSE)
#  listing_agent_started_at   :datetime
#  listing_agent_finished_at  :datetime
#  listing_agent_completed    :boolean(1)      default(FALSE)
#

class FullEvent < Event
  define_index do
    indexes :title, :sortable => true
    indexes venue.name, :as => :venue, :sortable => true
    # neighborhood, city or state
    indexes venue.neighbourhood.name, :as => :neighborhood, :sortable => true
    indexes venue.city.name, :as => :city, :sortable => true
    indexes venue.region.name, :as => :region, :sortable => true
    indexes venue.city.region_grouping.keywords, :as => :region_grouping_keywords, :sortable => false
    
    has :venue_id
    has :event_type_id
    has :start_date, :as => :open_date
    has :end_date, :as => :close_date
    has :updated_at
    has :enabled
    has event_type(:is_reception), :as => :is_reception
    where '`users`.status = 1' #Rejects exhibitions from not activated venues and events that marked as reception 

    set_property :delta => true
    set_property :min_infix_len => 1
    set_property :group_concat_max_len => 8192
  end
  
  def index_corresponding_full_event
    
  end
end
