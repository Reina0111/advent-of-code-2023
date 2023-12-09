require_relative "../lib/helper"

class Solution6
  include Helper

  FILE_NAME = "6th-day/input.txt"

  def solution()
    data.map { |time, distance| simple_check(time, distance) }.inject(:*)
  end

  def solution_part2()
    first_win = find_first_possible_win(data2[0], data2[1])
    last_win = find_last_possible_win(data2[0], data2[1])

    data2[0] - first_win - (data2[0] - last_win) + 1
  end

  def search_changing_point(start, ending)
    middle = (start + ending) / 2
    
    if ((data2[0] - start) * start > data2[1] && (data2[0] - middle) * middle < data2[1]) ||
      ((data2[0] - start) * start < data2[1] && (data2[0] - middle) * middle > data2[1])
      # winning in start and loosing in middle or loosing in start and winning in middle
      return search_changing_point(start, middle)
    elsif ((data2[0] - ending) * ending > data2[1] && (data2[0] - middle) * middle < data2[1]) ||
      ((data2[0] - ending) * ending < data2[1] && (data2[0] - middle) * middle > data2[1])
      # winning in start and loosing in middle or loosing in start and winning in middle
      return search_changing_point(middle, ending)
    end
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

  def find_first_possible_win(time, distance)    
    for speed in (0..time)
      time_until_distance = time - speed

      return speed if time_until_distance * speed > distance
    end
  end

  def find_last_possible_win(time, distance)
    speed = time   
    while speed > 0
      time_until_distance = time - speed

      return speed if time_until_distance * speed > distance

      speed -= 1
    end
  end

  def data2
    lines = read_file(FILE_NAME)
    time = lines.first.split(":")[1].split(" ").join("").to_i
    distance = lines.last.split(":")[1].split(" ").join("").to_i

    [time, distance]
  end
end