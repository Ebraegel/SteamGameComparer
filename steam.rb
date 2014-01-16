require 'open-uri'
require 'json'
require_relative './configuration.rb'


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

  def get_games
    conn = open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{API_KEY}&steamid=#{@steamid}&format=json")
    json_hash = JSON.parse(conn.read)
    games_hash = json_hash["response"]["games"]
    @games = games_hash.map { |hash| hash["appid"] }
  end

  def self.all
  ObjectSpace.each_object(self).each { |object| object.get_games}
  end

end