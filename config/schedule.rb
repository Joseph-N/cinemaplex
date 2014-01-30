set :output, "/home/jose/cron_log.log"

every 1.day, :at => '12:00 am' do
	rake "movies:populate"
end
