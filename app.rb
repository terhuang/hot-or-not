require 'json'
require 'sinatra'
require 'simple_oauth'
require 'excon'

# enables me to save the number somewhere semi permanent
enable  :sessions

# this is the method that compares your number to the random number
def hot_or_not(guessed_number, random_number)

  if guessed_number < random_number    # The guess is too cold
    message = "the guess is too cold, bro. try again."
  elsif guessed_number > random_number # The guess is too hot
    message = "the guess is too hot, man. try again."
  else                       # The guess is juuuust right
    message = "damn it! now you've gone and ended the game."
  end

  # output the comparison results
  return message 
end

# this is the homepage
get('/') do
  
  # this is where I generate a random number and save it in session
  session['random_number'] = rand(1000)

  # gotta puts it for ya to see
  puts ">>>>>>>>>>>>>> The random number is: " + (session['random_number']).to_s
  
  # we use erb home to show the html
  erb :home
  
end

# post request to /guess
post('/guess') do 
  
  # convert your number to integer
  guessed_number = (params[:number]).to_i

  # return the message on screen from method
  @answer = hot_or_not(guessed_number, session["random_number"])

  erb :home
end
