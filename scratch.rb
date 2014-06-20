require 'sinatra'

get '/a-web-page' do
  "Woah, this web site is AMAZING"
end

post '/secrets' do
  params[:message].reverse
end
