require_relative "../lib/helper"

class Solution8
  include Helper

  FILE_NAME = "8th-day/input.txt"

  def solution()
    current = "AAA"
    finish = "ZZZ"
    steps = 0
    navigation_len = navigation.length - 1

    while current != finish
      current = data[current][(navigation[steps % navigation_len]).to_sym]
      steps += 1
    end

    steps
  end

  def solution_part2()
    current = data.keys.filter { |node| node.end_with?("A") }
    finish = data.keys.filter { |node| node.end_with?("Z") }
    navigation_len = navigation.length - 1

    steps_array = []

    current.each do |c|
      s = 0
      while !finish.include?(c)
        c = data[c][(navigation[s % navigation_len]).to_sym]
        s += 1
      end
      steps_array << s
    end

    # we are getting Least common multiple of all paths
    steps_array.reduce(1, :lcm)
  end

  def navigation
    return @navigation if @navigation

    data

    @navigation
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)
    @navigation = lines[0].split("")

    @data = lines[2..-1].map { |line| line_to_node(line) }.to_h
  end

  def line_to_node(line)
    position, moves = line.split(" = ")
    
    moves = moves.split(/\(|,|\)| /).reject(&:empty?)
    
    [position, { "L": moves[0], "R": moves[1] }]
  end
end