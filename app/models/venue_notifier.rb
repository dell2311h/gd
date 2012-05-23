class VenueNotifier < ActionMailer::Base
	def activation_instructions(venue)
		subject       "Activation Instructions"
		from          "noreply@gallerydog.info" 
		recipients    venue.email
		sent_on       Time.now
		body          :account_activation_url => activate_url(venue.perishable_token)
	end

	def welcome(venue)
		subject       "Welcome to the gallerydog!"
		from          "noreply@gallerydog.info"
		recipients    venue.email
		sent_on       Time.now
		body          :root_url => root_url
	end

	def exhibition(exhibition,mail)
		subject       "Exhibition information"
		from          mail.from
		recipients    mail.to
		sent_on       Time.now
		body          :exhibition => exhibition, :mail => mail
	end	

	def event(event,mail)
		subject       "Event information"
		from          mail.from
		recipients    mail.to
		sent_on       Time.now
		body          :event => event, :mail => mail
	end

	def venue(venue,mail)
		subject       "Venue information"
		from          mail.from
		recipients    mail.to
		sent_on       Time.now
		body          :venue => venue, :mail => mail
	end

end