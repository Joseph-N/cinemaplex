class Cinema < ActiveRecord::Base
  belongs_to :movie
  has_many :contacts
  has_many :show_times

  def as_json(options = {})
  	{
  		:id => self.id,
  		:name => self.name,
  		:show_times => self.show_times,
  		:contacts => self.contacts
  	}
  end
end
