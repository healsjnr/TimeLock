$:.unshift File.dirname(__FILE__)
require 'timelock/Puzzle.rb'
require 'timelock/SHA256Puzzle.rb'
require 'timelock/ScryptPuzzle.rb'
require 'timelock/SquaringPuzzle.rb'

class TimeLockError < StandardError; end

class TimeLock

  VALID_ALGORITHMS = Puzzle.algorithms.keys

  def self.new_puzzle algorithm, params
    raise TimeLockError.new("Inavlid algorithm: #{algorithm}") unless VALID_ALGORITHMS.include? algorithm
    Puzzle.algorithms[algorithm].new params
  end

end

