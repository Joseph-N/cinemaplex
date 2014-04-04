namespace :movies do
	desc "Populate db with movies showing in cinemas"
	task :populate => [:environment, 'db:reset', 'server:restart'] do
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'
		require 'tmdb'

		base_url = "http://flix.co.ke"
		url = "http://flix.co.ke/Frontpage/Listings"
		imdb_key_length = 8

		doc = Nokogiri::HTML(open(url))

		#init tmdbmovie
		tmdb =  Tmdb.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
		tmdbmovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		
		puts "-"*80

		doc.css(".min-width div form").each do |entry|
			flix_title = entry.at_css("span").text
			flix_description = entry.at_css('br').next.text

			flix_avator = base_url + entry.at_css("input")['src']
			imdb_key = flix_avator.gsub(/[\D100]/,'').insert(0,'tt')

			if imdb_key.size < 8
				zeros_to_add = 8 - imdb_key.size
				imdb_key = imdb_key.insert(2, 0.to_s * zeros_to_add)
			end

			puts "Found: #{flix_title}"
			puts "Looking up  #{flix_title} with imdb_key #{imdb_key} on TheMovieDatabase "

			movie_details =  tmdbmovie.search_by_imdb_id(imdb_key)

			if movie_details["movie_results"].any?
				puts "Found Movie with #{imdb_key}!!!"
				# title = movie_details["movie_results"][0]["title"]

				puts "Getting full movie information......"
				movie_info = tmdbmovie.find(movie_details["movie_results"][0]["id"])
			else
				puts "Ooops!! I did not get results with imdb_key #{imdb_key}"
				puts "I will try searching with name instead.."
				search_term = flix_title.gsub(/\(.*?\)|2D|3D/,'')
				search_results = tmdbmovie.search(search_term)
				if search_results["results"].any?
					puts "Yaay!! Found Movie"
					puts "Getting full movie information......"
					movie_info = tmdbmovie.find(search_results["results"][0]["id"])
				end

			end

			description = movie_info["overview"]
			poster =  movie_info["poster_path"]
      backdrop = movie_info["backdrop_path"]

			movie = Movie.create!(title: flix_title, description: description, poster: poster, backdrop: backdrop)
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
