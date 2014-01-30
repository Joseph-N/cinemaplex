class ShowTime < ActiveRecord::Base
  belongs_to :cinema

  	def as_json(options = {})
		{
			:id	=> self.id,
			:time => self.hour.strftime("%I:%M%P")
		}
	end
end
