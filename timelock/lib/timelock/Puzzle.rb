$:.unshift File.dirname(__FILE__)

class Puzzle

	class << self
		def algorithms
      @algorithms ||= Hash.new
    end
	end

	attr_reader :params, :puzzle, :key
	
	def initialize params
		@params = params
		@puzzle =  Hash.new
	end

	def self.inherited(child_class)
		sym = child_class.name.delete('Puzzle').downcase.to_sym
		algorithms[sym] = child_class
		super
	end
	
end