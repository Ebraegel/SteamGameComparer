require 'rubygems'
require 'sinatra'
require './steam.rb'

get '/form' do
  erb :form
end

post '/form' do
  API_KEY = params[:api_key]
  Person1 = Person.new(params[:person1])
  Person2 = Person.new(params[:person2])
  Person3 = Person.new(params[:person3])
  Person.get_all_games
  Person.collect_games
  Person.get_master_game_list
  Person.compare_all_games
end