require_relative "../lib/helper"

class Solution6
  include Helper

  FILE_NAME = "6th-day/input.txt"

  def solution()
    data.map { |time, distance| simple_check(time, distance) }.inject(:*)
  end

  def solution_part2()
    simple_check(data2[0], data2[1])
  end

  def data
    return @data if @data
    
    lines = read_file(FILE_NAME)
    time = lines.first.split(":")[1].split(" ").map(&:to_i)
    distance = lines.last.split(":")[1].split(" ").map(&:to_i)

    @data = time.zip(distance)
  end

  def simple_check(time, distance)
    possible_wins = 0
    
    for speed in (0..time)
      time_until_distance = time - speed

      possible_wins += 1 if time_until_distance * speed > distance
    end

    possible_wins
  end

  def data2
    lines = read_file(FILE_NAME)
    time = lines.first.split(":")[1].split(" ").join("").to_i
    distance = lines.last.split(":")[1].split(" ").join("").to_i

    [time, distance]
  end
end