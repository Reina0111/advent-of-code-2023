require_relative "../lib/helper"

class Solution11
  include Helper

  FILE_NAME = "11th-day/input.txt"

  def solution()
    data[:galaxies].each_with_index.map { |_, index| get_distance_for_galaxy(index, 2) }.sum
  end

  def solution_part2()
    data[:galaxies].each_with_index.map { |_, index| get_distance_for_galaxy(index, 1000000) }.sum
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    data = {
      galaxies: [],
      empty_rows: [],
      empty_columns: [],
    }
    max_row = lines.count - 1
    max_column = lines[0].length - 1

    lines.each_with_index do |line, row|
      line.split("").each_with_index.map { |v, column| data[:galaxies] << [row, column] if v == "#" }
    end

    data[:empty_rows] = (0..max_row).to_a - data[:galaxies].map { |row, _| row }.uniq
    data[:empty_columns] = (0..max_column).to_a - data[:galaxies].map { |_, column| column }.uniq

    @data = data
  end

  def get_distance_for_galaxy(galaxy_index, expansion_value)
    galaxy = data[:galaxies][galaxy_index]
    galaxies = data[:galaxies][galaxy_index+1..-1]


    dist = 0
    galaxies.each do |row, column|
      row_range = ([galaxy[0], row].min..[galaxy[0], row].max - 1)
      double_rows = data[:empty_rows].filter { |row| row_range.include?(row) }.count
      column_range = ([galaxy[1], column].min..[galaxy[1], column].max - 1)
      double_columns = data[:empty_columns].filter { |column| column_range.include?(column) }.count

      single_dist = row_range.count + column_range.count + (double_columns + double_rows) * (expansion_value - 1)
      dist += single_dist
    end

    dist
  end
end