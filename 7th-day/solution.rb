require_relative "../lib/helper"

class Solution7
  include Helper

  FILE_NAME = "7th-day/input.txt"

  def solution()
    data.sort_by { |hand| hand[:points] }.each_with_index.map do |hand, index|
      hand[:bid].to_i * (index + 1)
    end.sum
  end

  def solution_part2()
    data2.sort_by { |hand| hand[:points] }.each_with_index.map do |hand, index|
      hand[:bid].to_i * (index + 1)
    end.sum
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    @data = lines.map { |line| line_to_hand(line) }
  end

  CARDS1 = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

  def line_to_hand(line)
    hand, bid = line.split(" ")

    points = hand.reverse.split("").each_with_index.map { |card, index| (1 + CARDS1.index(card)) * 100**index }.sum

    points += 10000000000 * get_type(hand)
    result = {
      hand: hand,
      bid: bid,
      points: points
    }

    result
  end

  def get_type(hand)
    count = CARDS1.map { |card| hand.scan(card).count }.filter { |c| c > 0 }.sort.reverse

    case count
    when [5]
      7
    when [4, 1]
      6
    when [3, 2]
      5
    when [3, 1, 1]
      4
    when [2, 2, 1]
      3
    when [2, 1, 1, 1]
      2
    else
      1
    end
  end
  

  def data2
    return @data2 if @data2

    lines = read_file(FILE_NAME)

    @data2 = lines.map { |line| line_to_hand2(line) }
  end

  CARDS2 = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]

  def line_to_hand2(line)
    hand, bid = line.split(" ")

    points = hand.reverse.split("").each_with_index.map { |card, index| (1 + (CARDS2.index(card) || -1)) * 100**index }.sum

    points += 10000000000 * get_type2(hand)
    result = {
      hand: hand,
      bid: bid,
      points: points
    }

    result
  end

  def get_type2(hand)
    count = CARDS2.map { |card| hand.scan(card).count }.filter { |c| c > 0 }.sort.reverse
    count = [0] if count.length == 0
    jokers = hand.scan("J").count

    count[0] += jokers || 0

    case count
    when [5]
      7
    when [4, 1]
      6
    when [3, 2]
      5
    when [3, 1, 1]
      4
    when [2, 2, 1]
      3
    when [2, 1, 1, 1]
      2
    else
      1
    end
  end
end