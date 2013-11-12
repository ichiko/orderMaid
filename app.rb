class App < Sinatra::Base
	register Sinatra::Reloader

	get '/' do
		haml :index
	end

	get %r{^/stylesheets/(.*)\.css} do
		scss :"scss/#{params[:captures][0]}"
	end

end