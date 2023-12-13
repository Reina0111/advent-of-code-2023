require_relative "../lib/helper"

class Solution12
  include Helper

  FILE_NAME = "12th-day/input.txt"

  def solution()
    # data.map { |line| count_correct(line) }.sum
    data2.map { |line| count_by_parts(line) }.sum
  end

  def solution_part2()
    data3.map { |line| count_by_parts(line) }.sum
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
        sequence: sequence.split(',').map(&:to_i),
        sequence_regex: "^[\\.]*\#{" + sequence.split(',').join("}[\\.]+\#{") + "}[\\.]*$",
      }
    end

    @data
  end

  def data3
    return @data3 if @data3

    lines = read_file(FILE_NAME)
    @data3 = []

    lines.each do |line|
      view, sequence = line.split(" ")

      el = {
        view: (view + "?") * 4 + view,
        sequence: sequence.split(',').map(&:to_i) * 5,
      }

      el[:sequence_regex] = "^[\\.]*\#{" + el[:sequence].join("}[\\.]+\#{") + "}[\\.]*$",

      @data3 << el
    end

    @data3
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
    puts line[:view]
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

      possibilities << seq_possibilities.uniq
    end

    # mam coś w stylu [["..??##", "....##"], ["..#?##"], ["?.??##"]]
    # potrzebuję teraz z każdego zestawu brać po 1 elemencie i sprawdzać czy taki nowy zestaw nie ma ze sobą sprzeczności i czy się nie najeżdżają przedziały
    results = []

    to_check = possibilities[0]

    for i in (1..possibilities.length - 1)
      to_check = to_check.product(possibilities[i]).map { |l| l.flatten.sort }.uniq
    end

    for i in (0..to_check.length - 1)
      results << combine_possibilities(to_check[i], line)
    end

    results.reject(&:nil?).uniq.count
  end

  def recursive()

  end

  def combine_possibilities(possibilities, line)
    result = 0
    try = ""

    for i in (0..line[:view].length-1) do
      letters = possibilities.map { |p| p[i] }.reject { |l| l == "?" }.uniq
      letters = ["."] if letters.empty?

      try += letters.first if letters.count == 1
    end

    # puts "#{try} #{try.length == line[:view].length && try.match?(/#{line[:sequence_regex]}/)}"

    if try.length == line[:view].length && try.match?(/#{line[:sequence_regex]}/)
      try
    else
      nil
    end
  end
end