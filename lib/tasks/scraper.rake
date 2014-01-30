namespace :movies do
	desc "Populate db with movies showing in cinemas"
	task :populate => :environment do
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'

		url = "http://flix.co.ke/Frontpage/Listings"
		doc = Nokogiri::HTML(open(url))

		# new_cinema = new_movie.cinemas.build
		# new_showtime = new_cinema.show_times.build
		# new_contacts = new_cinema.contacts.build

		doc.css(".min-width div form").each do |entry|
			title = entry.at_css("span").text
			description = entry.at_css('br').next.text

			puts "Found: #{title}"
			puts "----> Saving #{title} ...."

			movie = Movie.create!(title: title.strip, description: description.strip)
			puts "----> Successfully saved #{movie.title}"
			puts "\n"

			puts "Saving cinemas for #{movie.title}"
			create_cinemas_for(movie, entry)
		end
	end	

	def create_cinemas_for(movie, entry)
			entry.search("br+ strong").each do |el|
				puts "    ---> Found: #{el.text}"
				cinema = movie.cinemas.create!(name: el.text.strip)
				puts "	        > Saved #{cinema.name}. I will now save contact details for #{cinema.name} "

				save_contact_details_for(cinema, el)
			end
	end

	def save_contact_details_for(cinema, el)
		phones = []
	    while next_el = el.at('+ a', '+ br + a')
	      el = next_el
	      phones << el.text
	    end
	    phones.each do |number|
	    	cinema.contacts.create!(number: number.strip)
	    end
	    puts "	                    > Success! I saved #{phones.size} contacts for #{cinema.name}"
	    puts "                      > I will now save the show times"

	    save_show_times_for(cinema, el)
	end

	def save_show_times_for(cinema, el)
		times = el.at('+ br').next.text
		times.split(',').each do |time|
			cinema.show_times.create!(hour: time)
		end  
		puts "                           > Successfully saved show times for #{cinema.name}"
	end

end