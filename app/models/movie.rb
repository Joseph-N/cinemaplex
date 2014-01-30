class Movie < ActiveRecord::Base
	has_many :cinemas

	def as_json(options = {})
		{
			:id	=> self.id,
			:title => self.title,
			:description => self.description,
			:avator_url => self.avator,
			:cinemas => self.cinemas
		}
	end
end
