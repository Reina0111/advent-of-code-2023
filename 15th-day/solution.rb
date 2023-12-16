require_relative "../lib/helper"

class Solution15
  include Helper

  FILE_NAME = "15th-day/input.txt"

  def solution()
    # puts "#{data.count}"

    commands.map { |command| hashmap[command] }.sum
  end

  def solution_part2()
    boxes.map { |k, v| (k + 1) * get_focusing_power(v) }.sum
  end

  def commands
    return @commands if @commands

    @commands = File.read(FILE_NAME).split(',')
  end

  def hashmap
    return @hashmap if @hashmap

    @hashmap = {}

    commands.uniq.each do |command|
      result = 0
      ascii = command.split('').map { |letter| letter.ord }

      ascii.each do |value|
        result += value
        result *= 17
        result = result % 256
      end

      @hashmap[command] = result
    end

    @hashmap
  end

  def hashmap2
    return @hashmap2 if @hashmap2

    @hashmap2 = {}

    hash_commands = commands.map { |command| command.split(/-|=/).first }.uniq
    hash_commands.each do |command|
      result = 0
      ascii = command.split('').map { |letter| letter.ord }

      ascii.each do |value|
        result += value
        result *= 17
        result = result % 256
      end

      @hashmap2[command] = result
    end

    @hashmap2
  end

  def boxes
    return @boxes if @boxes

    boxes = {}
    (0..255).map { |i| boxes[i] = [] }

    commands.each do |command|
      _, name, action, number = command.match(/([^-=]*)([-=])(\d*)/).to_a
      box_index = hashmap2[name]

      next if action.nil?

      case action
      when "-"
        boxes[box_index].filter! { |el| el[0] != name }
      when "="
        index = boxes[box_index].index { |el| el[0] == name }
        if index
          boxes[box_index][index][1] = number.to_i
        else
          boxes[box_index] << [name, number.to_i]
        end
      end
    end

    @boxes = boxes
  end

  def get_focusing_power(box)
    result = 0
    box.each_with_index do |el, index|
      result += el[1] * (index + 1)
    end

    result
  end
end