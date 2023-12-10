require_relative "../lib/helper"

class Solution10
  include Helper

  FILE_NAME = "10th-day/input.txt"

  def solution()
    get_loop_distance / 2
  end

  def solution_part2()
    new_data = []
    data.each_with_index do |line, index|
      new_data << line.each_with_index.map do |element, index2| 
        TILES_IN_LOOP.include?([index, index2]) ? element : [".", []]
      end
    end
    new_data
    # new_data.each { |d| puts d.map { |a| a[0] }.join("") }

    new_data = divide_map(new_data)
    # new_data.each { |d| puts d.map { |a| a[0] }.join("") }

    [new_data.flatten.filter { |a| a == "A" }.count, new_data.flatten.filter { |a| a == "B" }.count]
  end

  PIPE_TO_DIRECTIONS = {
    "S": ["U","D","L","R"],
    "-": ["L","R"],
    "|": ["U","D"],
    "L": ["U","R"],
    "J": ["U","L"],
    "7": ["D","L"],
    "F": ["D","R"],
    ".": [],
  }
  def data
    return @data if @data

    lines = read_file(FILE_NAME)
    @data = []
    s_index = nil

    @data = lines.each_with_index.map do |line, index|
      @start = [index, s_index] if (s_index = line.index("S"))
      line.split("").reject { |e| e == "\n" }.map { |pipe| [pipe, PIPE_TO_DIRECTIONS[pipe.to_sym]] }
    end

    @data
  end

  def start
    return @start if @start

    data

    @start
  end

  TILES_IN_LOOP = []
  def get_loop_distance()
    move = data[start[0]][start[1]][1].filter { |move| correct_move(move, start) }.first
    current_index = start
    next_position = nil
    distance = 0
    loop do
      TILES_IN_LOOP << current_index
      case move
      when "U"
        current_index = [current_index[0] - 1, current_index[1]]
        move = (data[current_index[0]][current_index[1]][1] - ["D"]).first
      when "D"
        current_index = [current_index[0] + 1, current_index[1]]
        move = (data[current_index[0]][current_index[1]][1] - ["U"]).first
      when "L"
        current_index = [current_index[0], current_index[1] - 1]
        move = (data[current_index[0]][current_index[1]][1] - ["R"]).first
      when "R"
        current_index = [current_index[0], current_index[1] + 1]
        move = (data[current_index[0]][current_index[1]][1] - ["L"]).first
      end
      distance += 1
      break if current_index == start
    end

    distance
  end

  def correct_move(move, index)
    case move
    when "U"
      data[index[0] - 1][index[1]][1].include?("D")
    when "D"
      data[index[0] + 1][index[1]][1].include?("U")
    when "L"
      data[index[0]][index[1] - 1][1].include?("R")
    when "R"
      data[index[0]][index[1] + 1][1].include?("L")
    else
      false
    end
  end

  LEFT_RIGHT_MAP = {
    "-L": { "A": ["D"], "B": ["U"] },
    "-R": { "A": ["U"], "B": ["D"] },
    "|U": { "A": ["L"], "B": ["R"] },
    "|D": { "A": ["R"], "B": ["L"] },
    "LU": { "A": ["L", "D"], "B": [] },
    "LR": { "A": [], "B": ["L", "D"] },
    "JU": { "A": [], "B": ["R", "D"] },
    "JL": { "A": ["R", "D"], "B": [] },
    "7D": { "A": ["U", "R"], "B": [] },
    "7L": { "A": [], "B": ["U", "R"] },
    "FD": { "A": [], "B": ["U", "L"] },
    "FR": { "A": ["U", "L"], "B": [] },
  }
  def divide_map(my_data)
    move = my_data[start[0]][start[1]][1].filter { |move| correct_move(move, start) }.first # f.e. move == "U"
    current_index = start # f.e current_index == [1,1]
    loop do
      my_data = update_left_rights(move, current_index, my_data)
      case move
      when "U"
        current_index = [current_index[0] - 1, current_index[1]]
        move = (my_data[current_index[0]][current_index[1]][1] - ["D"]).first
      when "D"
        current_index = [current_index[0] + 1, current_index[1]]
        move = (my_data[current_index[0]][current_index[1]][1] - ["U"]).first
      when "L"
        current_index = [current_index[0], current_index[1] - 1]
        move = (my_data[current_index[0]][current_index[1]][1] - ["R"]).first
      when "R"
        current_index = [current_index[0], current_index[1] + 1]
        move = (my_data[current_index[0]][current_index[1]][1] - ["L"]).first
      end
      break if current_index == start
    end

    my_data
  end

  def update_left_rights(move, index, my_data) # f.e move == "L"
    current_position = my_data[index[0]][index[1]] # f.e ["-", ["L", "R"]]

    mapping = LEFT_RIGHT_MAP["#{current_position[0]}#{move}".to_sym]
    return my_data unless mapping
    # puts "update start #{current_position} #{index} #{mapping}"
    current_index = index

    mapping.each do |key, directions|
      # puts "halo #{key} #{directions}"
      directions.each do |direction|
        case direction.to_s
        when "U"
          current_index = [index[0] - 1, index[1]]
        when "D"
          current_index = [index[0] + 1, index[1]]
          # puts "halo #{current_index}"
        when "L"
          current_index = [index[0], index[1] - 1]
        when "R"
          current_index = [index[0], index[1] + 1]
        end

        next if current_index[0] < 0 || current_index[0] >= my_data.length || current_index[1] < 0 || current_index[1] >= my_data[0].length
        d = my_data[current_index[0]][current_index[1]]
        if d[0] == "."
          # puts "update #{index[0]} #{index[1] + 1}"
          my_data[current_index[0]][current_index[1]][0] = key.to_s
          my_data = expansion(key.to_s, current_index, my_data)
        end
      end
    end

    my_data
  end

  def expansion(a_or_b, index, my_data)
    directions = ["U", "D", "L", "R"]
    current_index = index

    directions.each do |direction|
      case direction.to_s
      when "U"
        current_index = [index[0] - 1, index[1]]
      when "D"
        current_index = [index[0] + 1, index[1]]
      when "L"
        current_index = [index[0], index[1] - 1]
      when "R"
        current_index = [index[0], index[1] + 1]
      end

      next if current_index[0] < 0 || current_index[0] >= my_data.length || current_index[1] < 0 || current_index[1] >= my_data[0].length

      # puts current_index.to_s
      d = my_data[current_index[0]][current_index[1]]
      if d[0] == "."
        my_data[current_index[0]][current_index[1]][0] = a_or_b
        my_data = expansion(a_or_b, current_index, my_data)
      end
    end

    my_data
  end
end