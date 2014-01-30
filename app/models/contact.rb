class Contact < ActiveRecord::Base
  belongs_to :cinema

  def as_json(options = {})
  	{
  		:id => self.id,
  		:number => self.number
  	}
  end
end
