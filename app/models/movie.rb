class Movie < ActiveRecord::Base
	has_many :cinemas

	def as_json(options = {})
		{
			:id	=> self.id,
			:title => self.title,
			:cinemas => self.cinemas
		}
	end
end
