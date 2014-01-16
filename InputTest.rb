require './steam.rb'

loop do
  puts "Enter a SteamID.  Or, enter \"compare\" to run the comparison!"
  input = STDIN.gets.chomp
  if input == "compare"
    break
  else
    Person.new(input)
  end
end

puts Person.all