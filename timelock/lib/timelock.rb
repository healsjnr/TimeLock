$:.unshift File.dirname(__FILE__)
require 'timelock/Puzzle.rb'
require 'timelock/SHA256Puzzle.rb'
require 'timelock/ScryptPuzzle.rb'
require 'timelock/SquaringPuzzle.rb'

class TimeLockError < StandardError; end

class TimeLock

	VALID_ALGORITHMS = [:SHA256, :Scrypt, :Squaring]

	def self.new_puzzle algorithm, params
		raise TimeLockError.new("Inavlid algorithm: #{algorithm}") unless VALID_ALGORITHMS.include? algorithm
		begin
			klass = Kernel.const_get("#{algorithm.to_s}Puzzle")
			raise TimeLockError.new("Unexpected error, class does not exist: #{algorithm}") unless klass.is_a?(Class)
			klass.new params
		rescue NameError
			raise TimeLockError.new("Unexpected error, class name not found: #{algorithm}Puzzle")
		end
	end

end

