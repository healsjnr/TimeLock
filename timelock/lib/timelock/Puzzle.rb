class Puzzle

  class << self
    def algorithms
      @algorithms ||= Hash.new
    end
  end

  attr_reader :params, :puzzle, :key

  # The following defines the interface for Puzzle class. All subclass must implement
  # these methods
  [:generate, :solve].each do |m| 
    "defining method #{m}"
    self.class_eval do
      define_method(m) do |*args|
        raise 'Method not implemented'
      end
    end
  end

  def initialize params
    @params = params
    @puzzle =  Hash.new
  end

  def self.inherited(child_class)
    sym = child_class.name.gsub('Puzzle', '').downcase.to_sym
    algorithms[sym] = child_class
    super
  end

end