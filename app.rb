require './lib/feed_finder'

require 'sinatra'
require 'json'
require 'erb'

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

before do 
  @feed = FeedFinder.create!(params[:feed]) if params[:feed]
end

post '/' do
  erb :index
end

post '/feed.json' do
  content_type :json

  if @feed
    return @feed.to_json
  else
    {:error => 'invalid request'}.to_json
  end
end

error 404 do
  File.read(File.join('public', '404.html'))
end
