require_relative "../lib/helper"

class Solution5
  include Helper

  FILE_NAME = "5th-day/input.txt"

  def solution()
    seeds.map { |s| change_long("seed", "location", s) }.min
  end

  def solution_part2()
    current_category = "seed"
    current_seeds = seeds2

    while current_category != "location"
      combined_map = data2[:maps][current_category][:changes].merge(current_seeds) { |key, o, n| o + n }
      joined_array = combined_map.keys.sort

      current_change = 0
      new_seeds = []
      new_seed_start = nil
      # puts "#{current_category} #{joined_array} #{current_seeds.keys.sort}"
      # puts "#{data2[:maps][current_category][:changes]}"
      # puts "#{combined_map}"

      joined_array.each do |key|
        # puts key
        if combined_map[key].any?(Integer)
          # puts "start of range"
          if new_seed_start && new_seed_start < key
            new_seeds << [new_seed_start + current_change, key - 1 + current_change]
            new_seed_start = key
          end
          current_change = combined_map[key].filter { |value| value.is_a?(Integer) }.first
        end
        if combined_map[key].include?(:seed_start)
          # puts "start of seed"
          new_seed_start = key
        end
        if combined_map[key].include?(:seed_end)
          # puts "end of seed"
          new_seeds << [new_seed_start + current_change, key + current_change]
          new_seed_start = nil
        end
        if combined_map[key].include?(:end)
          # puts "end of range #{current_change}"
          if new_seed_start
            new_seeds << [new_seed_start + current_change, key + current_change]
            new_seed_start = key + 1
          end
          current_change = 0
        end

      end

      current_seeds = new_seeds.map { |start, ending| [[start, [:seed_start]], [ending, [:seed_end]]]}.flatten(1).to_h
      current_category = data2[:maps][current_category][:destination_name]
    end

    current_seeds.keys.sort.first
  end

  def get_new_ranges(range, change_ranges)
    # our range is smaller or bigger than any changed range
    if range.last < change_ranges[0] || range.first > change_ranges[1]
      return [range]
    end

    if range.first < change_ranges[0]
      if range.last < change_ranges[1]
        return [(range.first..change_ranges[0] -1), (change_ranges[0]..range.last)]
      else
        return [(range.first..change_ranges[0] -1), (change_ranges[0]..change_ranges[1]), (change_ranges[1]+1..range.last)]
      end
    else # range.first >= change_ranges[0]
      if range.last < change_ranges[1]
        return [range]
      else
        return [(range.first..change_ranges[1]), (change_ranges[1]+1..range.last)]
      end
    end
  end

  def seeds2
    return @seeds2 if @seeds2

    @seeds2 = data2[:seeds]
  end

  def data2
    return @data2 if @data2

    lines = read_file(FILE_NAME)

    @data2 ||= {
      seeds: lines[0].split(/:/).last.split(" ").map(&:to_i).each_slice(2).map { |start, length| [[start, [:seed_start]], [start+length-1, [:seed_end]]] }.flatten(1).to_h,
      maps: {},
    }

    map = nil
    lines[1..-1].each do |line|
      if line.length < 2
        map = nil
      end
      # we are in the line "XXX-to-YYY map:"
      if line.index("map:")
        map = line.split(" ").first.split("-")
        @data2[:maps][map[0]] = { destination_name: map[2], changes: {} }
      elsif map
        dest, source, range = line.split(" ").map(&:to_i)
        dest_change = dest - source

        @data2[:maps][map[0]][:changes][source] = [dest_change]
        @data2[:maps][map[0]][:changes][source + range - 1] ||= []
        @data2[:maps][map[0]][:changes][source + range - 1] << :end
      end
    end

    @data2
  end

  def change_by_range(source, range)
    start_of_range = range.first
    end_of_range = range.last

    starting_range = map[:source][:changes].filter { |s, _| s.include?(start_of_range) }.first
    if starting_range
      new_range1_start = starting_range.first
      new_range2_end = starting_range.last

      map[:source][:changes]
    end
  end

  def change_short(source, seed)
    result = maps[source][:changes].filter { |a, _| a.include?(seed) }.first

    if result
      result = seed + result[1]
    else
      result = seed
    end

    [maps[source][:destination_name], result]
  end

  def change_long(source, desc, seed)
    while source != desc
      source, seed = change_short(source, seed)
    end

    seed
  end

  def maps
    @maps ||= @data[:maps]
  end

  def seeds
    @seeds ||= data[:seeds]
  end

  def data
    return @data if @data

    lines = read_file(FILE_NAME)

    @data ||= {
      seeds: lines[0].split(/:/).last.split(" ").map(&:to_i),
      maps: {},
    }

    map = nil
    lines[1..-1].each do |line|
      if line.length < 2
        map = nil
      end
      # we are in the line "XXX-to-YYY map:"
      if line.index("map")
        map = line.split(" ").first.split("-")
        @data[:maps][map[0]] = { destination_name: map[2], changes: [] }
      elsif map
        dest, source, range = line.split(" ").map(&:to_i)
        dest_change = dest - source
        source_range = (source..source + range - 1)

        @data[:maps][map[0]][:changes] << [source_range, dest_change]
      end
    end

    @data
  end
end