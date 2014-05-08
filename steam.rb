require 'open-uri'
require 'json'

require './configuration.rb' rescue LoadError

#Currently, configuration.rb just holds the API key.  Sample:
# API_KEY = "CNSEF8434NCDbunchacharactersSVLSNR"

class Person

  attr_accessor :games, :steamid
  #cattr_accessor :allgames

  @count = 0

  class << self
    attr_accessor :count
  end

  @@all_owned_games = []
  @@all_games = {}

  def initialize(steamid)
    @steamid = steamid.to_s
    @games = Array[]
    self.class.count += 1
  end

# Pulls down a person's owned games from the Steam API and makes an array of game ID numbers
  def get_games 
    conn = open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{API_KEY}&steamid=#{@steamid}&format=json")
    json_hash = JSON.parse(conn.read)
    games_hash = json_hash["response"]["games"]
    @games = games_hash.map { |hash| hash["appid"] }
  end

# Runs the get_games method on each person to populate their games list
  def self.get_all_games
  ObjectSpace.each_object(self).to_a.each { |object| object.get_games}
  end

# Takes each person's games array and crams them into the @@all_owned_games array
  def self.collect_games
    ObjectSpace.each_object(self).each { |person|
      @@all_owned_games << person.games
    }
  end

# Get all the games on steam and populate the @@all_games hash with appids => game titles.
  def self.get_master_game_list
    gamelist = open('http://api.steampowered.com/ISteamApps/GetAppList/v0001/')
    all_games_json = JSON.parse(gamelist.read)
    all_games = all_games_json["applist"]["apps"]["app"]
    all_array_of_hash = all_games.map { |pair| Hash[pair["appid"], pair["name"]] }
    all_array_of_hash.each do |pair|
      pair.each_pair {|key, value| @@all_games[key.to_i] = value }
    end
  end

  def self.all_games
    @@all_games
  end

  def self.all_owned_games
    @@all_owned_games
  end

  def self.compare_all_games
      # Count how many times each appid appears in @@all_owned_games
    count_appids = Hash[Person.all_owned_games.flatten.group_by { |x| x }.map { |k,v| [k,v.count] } ]
      # Keep only the appids that are owned by everyone
    common_appids = count_appids.keep_if { |k, v | v == Person.count}
    puts "OK, here's what the #{self.count} of you have in common:"
      # Match up those appids with the titles from @@all_games
    puts common_appids.map {|k, v| Person.all_games[k] }
  end

end
