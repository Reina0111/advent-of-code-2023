require_relative "../lib/helper"

class Solution4
  include Helper

  FILE_NAME = "4th-day/input.txt"

  def solution()
    games.map { |_id, game| game[:score] = get_game_score_first_part(game) }

    games.values.map { |game| game[:score] }.sum
  end

  def solution_part2()
    games.map { |_id, game| get_game_score_second_part(game) }

    games.values.map { |game| game[:count] }.sum
  end

  def games
    return @games if @games != nil

    lines = read_file(FILE_NAME)
    new_games = lines.map { |line| get_game(line) }
    @games = new_games.map { |game| [game[:id], game] }.to_h
  end

  def number_of_games
    @number_of_games ||= games.count
  end

  def get_game(line)
    game, winning_set, game_set = line.split(/:|\|/)

    {
      id: game.delete("^0-9").to_i,
      winning_set: winning_set.split(" "),
      game_set: game_set.split(" "),
      count: 1
    }
  end

  def get_game_score_first_part(game)
    correct_numbers = (game[:winning_set] & game[:game_set]).count

    if correct_numbers == 0
      0
    else
      2**(correct_numbers - 1)
    end
  end

  def get_game_score_second_part(game)
    correct_numbers = (game[:winning_set] & game[:game_set]).count

    for i in (1..correct_numbers) do
      break if game[:id] + i > number_of_games

      games[game[:id] + i][:count] += game[:count]
    end
  end
end