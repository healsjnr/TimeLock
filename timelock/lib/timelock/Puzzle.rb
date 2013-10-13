$:.unshift File.dirname(__FILE__)

class Puzzle
	attr_reader :params, :puzzle, :key
	
	def initialize params
		@params = params
		@puzzle =  Hash.new
	end
	
end