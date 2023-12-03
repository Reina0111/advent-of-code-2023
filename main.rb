require "benchmark"

Dir.glob("*-day/*.rb").each do |file|
  require_relative file
end

def main()
  times = []
  for i in (1..24)
    begin
      part = Object.const_get("Solution#{i}").new()
      
      puts "Solution for day #{i} 1st part: #{part.solution}"
      puts "Solution for day #{i} 2nd part: #{part.solution_part2}"
    rescue NameError
      # puts "Solution for day #{i} is not implemented yet"
    end
  end

  puts ""
  puts "Time statistics (average in 10 runs)"
  for i in (1..24)
    begin
      part = Object.const_get("Solution#{i}").new()
        
      time1 = Benchmark.realtime { (1..10).each { |_| part.solution } } / 10
      time2 = Benchmark.realtime { (1..10).each { |_| part.solution_part2 } } / 10
      puts "Task #{i}: 1st part #{(time1 * 1000).round(2)}ms, 2nd part #{(time2 * 1000).round(2)}ms"
    rescue NameError
      # puts "Solution for day #{i} is not implemented yet"
    end
  end
end

main()