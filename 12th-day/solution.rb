require_relative "../lib/helper"

class Solution12
  include Helper

  FILE_NAME = "12th-day/input.txt"

  def solution()
    # data.map { |line| count_correct(line) }.sum
    data2.map { |line| count_by_parts(line) }
  end

  def solution_part2()
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    @data = lines.map do |line|
      view, sequence = line.split(" ")

      {
        view: view,
        sequence: "[\\.\\?]*\#{" + sequence.split(',').join("}[\\.\\?]+\#{") + "}[\\.\\?]*",
        sequence2: "[\\.]*[\#\?]{" + sequence.split(',').join("}[\\.]+[\#\\?]{") + "}[\\.]*",
        count_ok: view.scan(/\./).count, # 7
        count_broken: sequence.split(',').map(&:to_i).sum, # 6
        count_unknown: view.scan(/\?/).count, # 4
        count_known: view.scan(/\#/).count # 2
      } # 3 - 2
    end

    @data
  end

  def data2
    return @data if @data

    lines = read_file(FILE_NAME)

    @data = lines.map do |line|
      view, sequence = line.split(" ")

      {
        view: view,
        sequence: sequence.split(',').map(&:to_i)
      }
    end

    @data
  end

  # suuuuper slow, will have to improve it somehow
  def count_correct(line)
    indexes = line[:view].split("").each_with_index.map { |spring, i| spring == "?" ? i : nil }.reject(&:nil?)

    count = 0
    if line[:count_known] > line[:count_unknown]
      indexes.permutation(line[:count_broken] - line[:count_known]).each do |permutation|
        next if permutation.sort != permutation
        view = line[:view].clone
        permutation.each do |index|
          view[index] = '#'
        end

        count += 1 if view.match?(/#{line[:sequence]}/)
      end
    else
      indexes.permutation(line[:count_unknown] - (line[:count_broken] - line[:count_known])).each do |permutation|
        next if permutation.sort != permutation
        view = line[:view].clone
        permutation.each do |index|
          view[index] = '.'
        end

        count += 1 if view.match?(/#{line[:sequence2]}/)
      end
    end

    # count, checked = count_recursive(line[:view], indexes, [], line[:sequence])
    puts line[:view]

    count
  end

  def count_by_parts(line)
    possibilities = []

    line[:sequence].each_with_index do |seq, index|
      seq_possibilities = []

      previous_seq_length = 0
      next_seq_length = 0

      if index > 0
        previous_seq_length = line[:sequence][0..index-1].sum + index
      end
      if index < line[:sequence].count - 1
        next_seq_length = line[:sequence][index+1..-1].sum + (line[:sequence].count - index - 1)
      end
      seq_length = line[:view].length - previous_seq_length - next_seq_length

      (0..seq_length-1).each do |range_start|
        view = line[:view].clone

        if view[(previous_seq_length + range_start..previous_seq_length + range_start + seq - 1)].match?(/[\#\?]{#{seq}}/)
          view[(previous_seq_length + range_start..previous_seq_length + range_start + seq - 1)] = "#" * seq 
          seq_possibilities << view
        end
      end

      possibilities << seq_possibilities
    end

    # mam coś w stylu [["..??##", "....##"], ["..#?##"], ["?.??##"]]
    # potrzebuję teraz z każdego zestawu brać po 1 elemencie i sprawdzać czy taki nowy zestaw nie ma ze sobą sprzeczności i czy się nie najeżdżają przedziały

    puts possibilities[0].to_s
  end

  def combine_possibilities(possibilities, length)
    result = 0

    for i in (0..length-1) do
      common = possibilities.map { |p| p[2] }.reject { |l| l == "?" }.uniq

      result += 1 if common.count == 1
    end

    return result == length
  end
end