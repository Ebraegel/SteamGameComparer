require 'open-uri'
require 'json'
require_relative './configuration.rb'

#Currently, configuration.rb just holds the API key.  Sample:
# API_KEY = "CNSEF8434NCDbunchacharactersSVLSNR"

#Grab all extant Steam games and makes an array of hashes 
#where keys are game ID numbers and values are the game titles as strings
gamelist = open('http://api.steampowered.com/ISteamApps/GetAppList/v0001/')
all_games_json = JSON.parse(gamelist.read)
all_games = all_games_json["applist"]["apps"]["app"]
all = all_games.map { |pair| Hash[pair["appid"], pair["name"]] }




class Person

  attr_accessor :games, :steamid

  def initialize(steamid)
    @steamid = steamid.to_s
    @games = Array[]
  end

  def get_games #Pulls down owned games from the Steam API and makes an array of game ID numbers
    conn = open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{API_KEY}&steamid=#{@steamid}&format=json")
    json_hash = JSON.parse(conn.read)
    games_hash = json_hash["response"]["games"]
    @games = games_hash.map { |hash| hash["appid"] }
  end

  def self.all #testing
  ObjectSpace.each_object(self).each { |object| object.get_games}
  end

end
