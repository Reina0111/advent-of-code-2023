require_relative "../lib/helper"

class Solution14
  include Helper

  FILE_NAME = "14th-day/input.txt"

  def solution()
    # puts "#{data.count}"

    data.map { |line| get_load(line) }.sum
  end

  def solution_part2()
    data[:galaxies].each_with_index.map { |_, index| get_distance_for_galaxy(index, 1000000) }.sum
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    data = []

    lines.each do |line|
      data << line.delete("\n").split('')
    end

    @data = data.map { |el| el.reverse }.transpose # we are rotating map by 90 degrees to counterclock wise (north is now to the left)
  end

  def get_load(row)
    total_lenght = row.length
    parts = row.join('').split("#").map { |part| part.split('') }
    parts.map! { |p| { length: p.length, count: p.filter { |el| el == "O" }.count } }

    current_lenght = total_lenght
    total_load = 0
    parts.each do |part|
      if part[:count] > 0
        total_load += (current_lenght + (current_lenght - part[:count] + 1)) * part[:count] / 2
      end

      current_lenght = current_lenght - part[:length] - 1
    end

    total_load
  end
end