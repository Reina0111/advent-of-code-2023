require_relative "../lib/helper"

class Solution16
  include Helper

  FILE_NAME = "16th-day/input.txt"

  def solution()
    start_move(0, 0, "R")

    # data.map { |l| puts l.map { |el| el[:visited] ? "#" : "." }.join('').to_s }
    data.map { |l| l.filter { |el| el[:visited] }.count }.sum
  end

  def solution_part2()
    length = data.length - 1
    height = data[0].length - 1
    rows = (0..length)
    columns = (0..height)
    directions = ["L", "R", "D", "U"]

    rows.map do |row|
      # puts "starting row #{row}"
      columns.map do |column|
        if ![0, length].include?(row) && ![0, height].include?(column)
          0
        else
          directions.map do |direction|
            reset_visited()
            start_move(row, column, direction)
            data.map { |l| l.filter { |el| el[:visited] }.count }.sum
          end.max
        end
      end.max
    end.max
  end

  NEXT_DIRECTIONS = {
    ".": {
      "L": ["L"],
      "R": ["R"],
      "D": ["D"],
      "U": ["U"],
    },
    "-": {
      "L": ["L"],
      "R": ["R"],
      "D": ["L", "R"],
      "U": ["L", "R"],
    },
    "|": {
      "L": ["D", "U"],
      "R": ["D", "U"],
      "D": ["D"],
      "U": ["U"],
    },
    "/": {
      "L": ["D"],
      "R": ["U"],
      "D": ["L"],
      "U": ["R"],
    },
    "\\": {
      "R": ["D"],
      "L": ["U"],
      "D": ["R"],
      "U": ["L"],
    },
  }

  PREVIOUS_DIRECTIONS = {
    ".": {
      "L": ["R"],
      "R": ["L"],
      "U": ["D"],
      "D": ["U"],
    },
    "-": {
      "L": ["R", "L"],
      "R": ["R", "L"],
      "U": ["U", "R", "L"],
      "D": ["D", "R", "L"],
    },
    "|": {
      "L": ["L", "D", "U"],
      "R": ["R", "D", "U"],
      "U": ["D", "U"],
      "D": ["D", "U"],
    },
    "/": {
      "R": ["R", "D"],
      "L": ["L", "U"],
      "D": ["R", "D"],
      "U": ["L", "U"],
    },
    "\\": {
      "R": ["R", "U"],
      "L": ["L", "D"],
      "D": ["L", "D"],
      "U": ["R", "U"],
    },
  }

  def data
    return @data if @data

    @data = []

    read_file(FILE_NAME).each do |line|
      new_row = []
      line.split('').each do |element|
        next if element == "\n"
        new_row << {
          element: element,
          visited: false,
          next_directions: NEXT_DIRECTIONS[element.to_sym],
          previous_directions: []
        }
      end
      @data << new_row
    end

    @data
  end

  def reset_visited
    @data.map! do |line|
      line.map do |el|
        el[:visited] = false
        el[:previous_directions] = []
        el
      end
    end
  end

  def start_move(row, column, direction)
    next_steps = [[row, column, direction]]
    # all_steps = [[row, column, direction]]
    i = 0

    while next_steps.count > 0
      current = next_steps.shift

      # puts current
      new_steps = move_light(current[0], current[1], current[2])
      next_steps += new_steps # - all_steps
      # all_steps = (all_steps + new_steps).uniq
      i += 1

      # if i % 100 == 0
        # data.map { |l| puts l.map { |el| el[:visited] ? "#" : "." }.join('').to_s }
        # puts next_steps.to_s
        # begin
        #   puts data[next_steps[0][0]][next_steps[0][1]]
        # rescue NoMethodError
        #   puts "blank"
        # end
      # end
    end
  end

  def move_light(row, column, direction)
    # puts "#{data[row][column]}" if row == 6 && column == 6 
    return [] if row < 0 || row > data.length - 1 || column < 0 || column > data[0].length - 1

    current_place = data[row][column]
    
    return [] if current_place[:previous_directions].include?(direction)
    
    current_place[:previous_directions] = (current_place[:previous_directions] + PREVIOUS_DIRECTIONS[current_place[:element].to_sym][direction.to_sym]).uniq
    current_place[:visited] = true

    @data[row][column] = current_place

    # puts "[#{row}][#{column}] - #{direction} #{current_place[:element]} #{current_place[:previous_directions]}"

    next_steps = []
    current_place[:next_directions][direction.to_sym].each do |dir|
      case dir.to_s
      when "L"
        next_steps << [row, column - 1, dir]
      when "R"
        next_steps << [row, column + 1, dir]
      when "D"
        next_steps << [row + 1, column, dir]
      when "U"
        next_steps << [row - 1, column, dir]
      end
    end

    next_steps
  end
end