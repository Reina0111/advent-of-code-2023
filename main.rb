Dir.glob("*-day/*.rb").each do |file|
  require_relative 'first-day/solution'
end

def read_file()
  lines = []
  File.open(FILE_NAME).read.each_line do |line|
    lines << line
  end

  lines
end


def main()
  for i in (1..24) do
    begin
      puts "Solution for day #{i} first part: #{send("solution#{i}")}"
      puts "Solution for day #{i} second part: #{send("solution#{i}_part2")}"
    rescue NoMethodError
      # puts "Solution for day #{i} is not implemented yet"
    end
  end
end

main()