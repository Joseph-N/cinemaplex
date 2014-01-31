set :output, "/home/jose/cron_log.log"

every 2.hours do
	rake "movies:populate"
end
