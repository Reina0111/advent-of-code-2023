FILE_NAME = "first-day/input.txt"

def get_number_from_line(line)
  first_digit = line[/\d/]
  last_digit = line.reverse[/\d/]

  "#{first_digit}#{last_digit}".to_i
end

def solution1()
  lines = read_file()

  numbers = lines.map { |line| get_number_from_line(line) }

  numbers.sum
end

SPELLED_DIGITS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
# The right calibration values for string "eighthree" is 83 and for "sevenine" is 79.
def change_words_to_digits(line)
  result_line = []

  # putting normal numbers to result array
  line.split("").each_with_index { |letter, index| result_line << [index, letter] if letter.to_i > 0 }

  # putting written numbers to result array
  for i in (0..line.length) do
    SPELLED_DIGITS.each_with_index do |word, digit|
      if line[i..line.length].start_with?(word)
        result_line << [i, digit + 1]
      end
    end
  end
  result = result_line.sort.map { |_, number| number }.join

  result
end

def solution1_part2()
  lines = read_file()

  numbers = lines.map { |line| get_number_from_line(change_words_to_digits(line)) }

  numbers.sum
end