require_relative "../lib/helper"

class Solution13
  include Helper

  FILE_NAME = "13th-day/input.txt"

  def solution()
    # puts "#{data.count}"

   data.map do |field|
    # puts "#{field}"
    rows = find_mirror_row(field).sum * 100
    columns = find_mirror_row(field.map { |el| el.reverse }.transpose.reverse).sum
    
    rows + columns
   end.sum
  end

  def solution_part2()
    # data[:galaxies].each_with_index.map { |_, index| get_distance_for_galaxy(index, 1000000) }.sum
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    tables = []
    table = []


    lines.each do |line|
      if line.delete("\n").empty?
        tables << table
        # tables << table.transpose

        table = []
      else
        table << line.delete("\n").split('')
      end
    end

    tables << table

    @data = tables
  end

  def find_mirror_row(table)
    mirror_indexes = []

    for i in (0..table.length - 2)
      mirror_indexes << i if table[i] == table[i+1]
    end

    # puts mirror_indexes.to_s

    true_mirror_indexes = []
    
    mirror_indexes.each do |index|
      length = [index + 1, table.length - index - 1].min
      first_half = table[index - length + 1..index]
      second_half = table[index+1..index + length]

      # puts "f #{first_half}"
      # puts "s #{second_half.reverse}"

      true_mirror_indexes << index if second_half.reverse == first_half
    end

    # puts "true #{true_mirror_indexes}"
    true_mirror_indexes.map { |i| i + 1 }
  end
end