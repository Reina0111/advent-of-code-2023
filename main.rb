Dir.glob("*-day/*.rb").each do |file|
  require_relative file
end

def main()
  for i in (1..24) do
    begin
      part = Object.const_get("Solution#{i}").new()
      puts "Solution for day #{i} first part: #{part.solution}"
      puts "Solution for day #{i} second part: #{part.solution_part2}"
    rescue NameError
      # puts "Solution for day #{i} is not implemented yet"
    end
  end
end

main()