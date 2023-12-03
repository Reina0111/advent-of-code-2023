require_relative "../lib/helper"

class Solution3
  include Helper

  FILE_NAME = "third-day/input.txt"

  def solution()
    numbers = {}

    scheme.each_with_index do |row, i|
      row.each_with_index do |element, j|
        if element.match?(/[^\.\d]/) # if element we are looking at is a symbol other than dot
          new_numbers = get_adjacent_numbers(i, j)
          # we can safely merge new found numbers to our list without duplicates,
          # because we are storing their positions as keys
          numbers.merge!(new_numbers)
        end
      end
    end

    numbers.values.sum
  end

  def solution_part2()
    # we remove all symbols that are not the "*" in this part of solution, as they are not needed
    scheme.map!{ |row| row.map! { |element| element.match?(/[\.\d\*]/) ? element : "." } }

    gear_ratios = []

    scheme.each_with_index do |row, i|
      row.each_with_index do |element, j|
        if element.match?(/\*/)
          new_numbers = get_adjacent_numbers(i, j)
          gear_ratios << new_numbers.values.inject(:*) if new_numbers.keys.count == 2
        end
      end
    end

    gear_ratios.sum
  end

  def scheme
    @scheme ||= read_file(FILE_NAME).map { |l| l.strip }.map { |l| l.split("") }
  end

  def max_width
    @max_width ||= scheme.first.length
  end

  def max_height
    @max_height ||= scheme.length
  end

  # method to get number with digit on given position
  # returns column number of first digit of number and number itself
  def get_number(row, column)
    line = scheme[row].join("")
    first_part = line[0..column-1]
    last_part = line[column..max_width]

    first_part = first_part.match(/\d*$/).to_s
    last_part = last_part.match(/^\d*/).to_s

    [column - first_part.length, (first_part + last_part).to_i]
  end

  # method to get all numbers adjacent to given position
  # returns hash where keys are coordinates of found numbers, and values are found numbers
  def get_adjacent_numbers(row, column)
    numbers = {}
    
    for i in ([row-1, 0].max..[row+1, max_width].min)
      for j in ([column-1, 0].max..[column+1, max_height].min)
        if scheme[i][j].match?(/\d/)
          number_start, number = get_number(i, j)
          numbers["#{i}-#{number_start}"] = number
        end
      end
    end

    numbers
  end
end