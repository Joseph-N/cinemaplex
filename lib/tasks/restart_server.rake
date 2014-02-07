namespace :server do
	desc "Restart Server"
	task :restart => [:environment] do
		app_location = "/home/jose/cinemaplex"
		if system("cd $app_location")
			p "Restarting rails application....."
			system("kill `cat tmp/pids/server.pid` && rails s -e production -d -p 4000")
			p "Successfully restarted rails server"
		end
	end
end