require_relative "../lib/helper"

class Solution2
  include Helper

  FILE_NAME = "second-day/input.txt"

  def solution()
    lines = read_file(FILE_NAME)

    games = lines.map { |line| line_to_game(line) }
    games.map { |game| correct_game(game) ? game[:id] : 0 }.sum
  end

  def solution_part2()
    lines = read_file(FILE_NAME)

    games = lines.map { |line| line_to_game(line) }
    games.map { |game| game[:red] * game[:blue] * game[:green] }.sum
  end

  BALL_QUANTITY = {
    "red": 12,
    "green": 13,
    "blue": 14
  }

  def get_number_of_balls(set, color)
    if (result = set.match(/(\d*) #{color}/))
      result[1].to_i
    else
      0
    end
  end

  def line_to_game(line)
    game_and_sets = line.split(/:|;/)
    game = game_and_sets[0]
    sets = game_and_sets[1..-1]
    
    {
      "id": game.delete("^0-9").to_i,
      "red": sets.map { |set| get_number_of_balls(set, "red") }.max,
      "green": sets.map { |set| get_number_of_balls(set, "green") }.max,
      "blue": sets.map { |set| get_number_of_balls(set, "blue") }.max,
    }
  end

  def correct_game(game)
    BALL_QUANTITY.keys.each do |color|
      return false if BALL_QUANTITY[color] < game[color]
    end

    true
  end
end