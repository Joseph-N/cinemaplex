class Movie < ActiveRecord::Base
	has_many :cinemas

	def as_json(options = {})
		{
			:id	=> self.id,
			:title => self.title,
      		:poster => self.poster,
      		:backdrop => self.backdrop,
			:description => self.description
		}
  end
end
