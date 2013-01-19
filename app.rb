require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require './models'

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    user = User.first(:username => "tom")
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [user.username, user.password]
  end

end

get '/' do
	"hello"
end

get '/edition/' do
	delivery = 1
	if params[:delivery_count]
		delivery = params[:delivery_count].to_i
	end

	@word = Word.first :delivery_order => delivery
	etag @word.delivery_order
	erb :edition
end

get '/sample/' do
	@word = Word.first :delivery_order => 1
	etag "sample"+@word.delivery_order
	erb :edition
end

get '/all' do
	protected!
	@words = Word.all
	erb :all
end



get '/new' do
	protected!
	erb :new
end

post '/create' do
	protected!
	Word.create(:word => params[:word], :definition => params[:definition])
	redirect '/all'
end

get '/edit/:id' do
	protected!
	@word = Word.get params[:id]
	erb :edit
end

post '/update/:id' do
	protected!
	@word = Word.get params[:id]
	@word.word = params[:word]
	@word.definition = params[:definition]
	@word.save
	redirect "/edit/#{@word.id}"
end

post '/delete/:id' do
	protected!
	@word = Word.get params[:id]
	@word.destroy
	redirect "/all"
end



# Not used.
# post "/validate_config/" do
#   if ["original", "recode"].include? params["edition_type"]
#   	"{\"valid\" : true}"
#   else
#   	"{\"valid\": false, \"errors\": [\"Please select a ReCodePrinter edition.\"]}"
#   end
# end