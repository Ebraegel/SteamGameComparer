 #!/usr/bin/env ruby

require_relative 'steam.rb' rescue LoadError
require_relative 'configuration.rb' rescue LoadError

loop do
  puts "Enter a SteamID.  Or, enter \"compare\" to run the comparison!"
  input = STDIN.gets.chomp
  if input == "compare"
    break
  else
    Person.new(input)
  end
end

puts "Hang on a moment, working on it..."
Person.get_all_games
Person.collect_games
Person.get_master_game_list
Person.compare_all_games