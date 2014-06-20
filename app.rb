require 'json'
require 'sinatra'
require 'simple_oauth'
require 'excon'

if ENV['RACK_ENV'] != "production"
  require 'dotenv'
  Dotenv.load ".env"
end

enable  :sessions
# Since Heroku only has the files in git and we prevent .env from being checked
# in; we can't use Dotenv on Heroku.
#
# Heroku sets an environment variable called `RACK_ENV` to "production" on ruby
# apps; so we use that to skip loading Dotenv.
#
# For all the rest of the variables we set in `.env` we'll use `heroku
# config:set VARIABLE_NAME="value"`:
#   https://devcenter.heroku.com/articles/config-vars#setting-up-config-vars-for-a-deployed-application


# def reverse(words)
#   new_words = []
#   words.split(" ").each do |word|
#     new_words.unshift(word.reverse)
#     #array.unshift is like array.push, but it prepends data to the beginning
#     # of an array instead of appending it to the end.
#   end

#   new_words.join(" ")
#   # This highly complex encryption algorithm will surely dupe the NSA!
# end


# def tweets(screen_name)
#   authorization_header = SimpleOAuth::Header.new("get",
#                                                  "https://api.twitter.com/1.1/statuses/user_timeline.json",
#                                                  { :screen_name => screen_name },
#                                                  { :consumer_key => ENV['TWITTER_API_KEY'],
#                                                    :consumer_secret => ENV['TWITTER_API_SECRET'] })

#   response = Excon.send("get", "https://api.twitter.com/1.1/statuses/user_timeline.json", {
#     :query => { :screen_name => screen_name },
#     :headers => { "Authorization" => authorization_header.to_s }
#   })

#   response = JSON.parse(response.body)
#   if response.respond_to?(:has_key?) && response.has_key?("errors")
#     messages = []
#     response["errors"].each do |error|
#       messages.push(error["message"])
#     end
#     raise "Woah! Lookit all these errors! #{messages.join("\n")}"
#   else
#     return response
#   end
#   # If only it were possible to re-use code without copying and pasting...
#   # http://guides.rubygems.org/make-your-own-gem/
# end

# QUOTES = ["It's life Jim, but not as we know it!",
#           "Safety Dance!",
#           "What is the airspeed velocity of a coconut laden swallow?"]

# Truly, great wisdom of the ages...

def hot_or_not(num_to_guess)
  while true
    guess = get_user_guess()   # "guess" is now an integer

    if guess < num_to_guess    # The guess is too cold
      puts "the guess is too cold, bro"
    elsif guess > num_to_guess # The guess is too hot
      puts "the guess is too hot, man"
    else                       # The guess is juuuust right
      puts "dang it. you got it."

      return
    end
  end
end

get('/') do
  # `get` is a sinatra method that lets us respond to HTTP requests, e.g.,
  # from a browser.
  # `get` takes two arguments:
  #   * a string for the path to respond to
  #   * a `block` of instructions to execute when a request is sent using the
  #     `GET` http verb. (Blocks are those `do ... end` things.)
  #     This comment is inside one right now!
  
  session['rand_number'] ||= rand(1000) 
  
  # @rand_number = rand(1000)
  puts "******************" 
  puts session['rand_number']

  # @words = QUOTES.sample
  # The `@` sign denotes an `instance variable`. This is how we share `data`
  # between a route and a view.

  erb :home
  # `erb` is a method that takes a symbol that corresponds to a file named in
  # the `views` folder.

  # In this case, we're saying "load the template file called `views/home.erb`,
  # process it with whatever `instance variables` are defined; and return the
  # result as a string.
end

post('/guess') do 
  puts "<<<<<<<<<<<<<<<<<<<<<<<< {params[:number]}"
  # puts "******************" + @rand_number.to_s
  
  guessed_number = (params[:number]).to_i

  # hot_or_not(guessed_number)


  # if guessed_number < 10
  #   answer = "that's less than ten"
  # else guessed_number > 10
  #   answer = "that's more than ten"
  # end
  
  # answer
end

post('/reverse') do
# Sinatra's `post` method is similar to `get`, except it responds only to
# `requests` sent with the `POST` http verb.

  unreversed_words = params[:words]
  # `params` is a hash provided by Sinatra that includes any `query variables`
  # or `form variables` sent with the request.
  #
  # Take the following form:
  # <form method="POST" action ="/reverse">
  # <textarea name="words"><%= @words %></textarea>
  # <button>Reversify!</button>
  # </form>
  #
  # When a visitor fills in the text box and clicks the "Reversify!" button it
  # will send an HTTP Post request to the '/reverse` path on whatever `server`
  # is running the app. The request will include a form variable named `words`
  # with a value of whatever the user put in.

  @words = reverse(unreversed_words)
  erb :home
  # We can call methods we defined earlier in the file from within a route
  # Because we're re-using the `home` template; we want to re-use the `@words`
  # instance variable; since it's being used to pre-fill the words textarea.
end

get('/tweets') do
  if ENV['TWITTER_API_KEY'].nil? || ENV['TWITTER_API_SECRET'].nil?
    "Hey!  Wait a second.  Look in app.rb and set up your Twitter API key and secret."
  elsif params[:screen_name]
    @tweets = tweets(params[:screen_name])
    erb :tweets
  else
    @tweets = []
    erb :tweets
  end
  # If someone requests this page without passing in a `screen_name` variable;
  # we want to default to an empty list of tweets.
  #
  # Don't believe me? Delete 94 and 96 - 98 and read the error message!
  # Why do you think that is there?

  # Which template do you think `erb` will use to render these tweets?
end
