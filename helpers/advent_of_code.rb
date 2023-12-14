module Helpers
  class AdventOfCode
    attr_reader :file

    def initialize(filepath)
      @file = File.readlines(filepath).map(&:strip)
    end
  end

  class AoC < AdventOfCode; end
end
