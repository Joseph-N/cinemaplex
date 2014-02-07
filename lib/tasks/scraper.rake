namespace :movies do
	desc "Populate db with movies showing in cinemas"
	task :populate => [:environment, 'db:reset', 'server:restart'] do
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'

		base_url = "http://flix.co.ke"
		url = "http://flix.co.ke/Frontpage/Listings"
		doc = Nokogiri::HTML(open(url))
		
		puts "-"*80

		doc.css(".min-width div form").each do |entry|
			title = entry.at_css("span").text
			description = entry.at_css('br').next.text
			avator = base_url + entry.at_css("input")['src']

			puts "Found: #{title}"
			puts "> Saving #{title} ...."

			movie = Movie.create!(title: title.strip, description: description.strip, avator: avator)
			puts "> Successfully saved #{movie.title}"
			puts "\n"

			puts "Saving cinemas for #{movie.title}"
			create_cinemas_for(movie, entry)

			puts "-"*70
		end
	end	

	def create_cinemas_for(movie, entry)
			entry.search("br+ strong").each do |el|
				puts "> Found: #{el.text}"
				cinema = movie.cinemas.create!(name: el.text.strip)
				puts "> Saved #{cinema.name}. I will now save contact details for #{cinema.name} "

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
	    puts "> Success! I saved #{phones.size} contacts for #{cinema.name}"
	    puts "> I will now save the show times"

	    save_show_times_for(cinema, el)
	end

	def save_show_times_for(cinema, el)
		times = el.at('+ br').next.text
		times.split(',').each do |time|
			cinema.show_times.create!(hour: time)
		end  
		puts "> Successfully saved show times for #{cinema.name} \n"
	end

end