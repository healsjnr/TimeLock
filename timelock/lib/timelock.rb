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

def time_lock_help
 puts "puzzle = TimeLock.new_puzzle :sha256, :iterations => 1, :threads => 1, :encryption => :aes_256_gcm"
 puts "seed = puzzle.generate"
 puts "key = puzzle.key"
 puts "solution = puzzle.solve(seed)"
 puts "solution == key"
end

# > help # print usage.
if __FILE__ == $0
  require 'pry'
  binding.pry
end

