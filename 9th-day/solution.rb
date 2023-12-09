require_relative "../lib/helper"

class Solution9
  include Helper

  FILE_NAME = "9th-day/input.txt"

  def solution()
    with_predictions = data.map { |key, array| [key, make_prediction(array)] }.to_h

    extrapolated = with_predictions.map { |key, array| [key, extrapolate(array)] }.to_h

    extrapolated.values.map { |array| array[0][-1] }.sum
  end

  def solution_part2()
    with_predictions = data.map { |key, array| [key, make_prediction(array)] }.to_h
    extrapolated = with_predictions.map { |key, array| [key, extrapolate_backwards(array)] }.to_h
    extrapolated.values.map { |array| array[0][-1] }.sum
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    @data = lines.each_with_index.map { |line, index| [index, line.split(' ').map(&:to_i)] }.to_h
  end

  def make_prediction(array)
    result = [array]
    current = array
    while current.uniq != [0]
      new_array = current.each_with_index.map { |el, index| (current[index+1] || 0) - el }[0..-2]

      result << new_array
      current = new_array
    end

    result
  end

  def extrapolate(array)
    index = array.length - 1

    while index > 0
      array[index - 1] << array[index][-1] + array[index - 1][-1]

      index -= 1
    end

    array
  end

  def extrapolate_backwards(array)
    index = array.length - 1
    array[index] << 0

    while index > 0
      array[index - 1] << array[index - 1][0] - array[index][-1]

      index -= 1
    end

    array
  end
end

# 10  13  16  21  30  45  68
#  3   3   5   9  15  23
#  0   2   4   6   8
#  2   2   2   2
#  0   0   0