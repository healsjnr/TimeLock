require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Timelock" do

  it 'should instantiate a valid SHA256 puzzle' do 
    puzzle = TimeLock.new_puzzle :sha256, :iterations => 1, :threads => 1, :encryption => :aes_256_gcm
  end
 
  it 'should instantiate a valid scrypt puzzle' do
    puzzle = TimeLock.new_puzzle :scrypt, :iterations => 1, :threads => 1 
  end
 
  it 'should instantiate a valid squaring puzzle' do
    puzzle = TimeLock.new_puzzle :squaring, :iterations => 1, :threads => 1 
  end

  it 'should instantiate a valid squaring puzzle' do
    expect {TimeLock.new_puzzle :other_alg, :iterations => 1, :threads => 1}.to raise_error 
  end

  
  describe "SHA256 tests" do

    let(:known_answers) { {:input => 'abc', :output => 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'}}

    it 'should produce known answer for single iteation' do
 
      known_answer_test 1     
      known_answer_test 2    
      known_answer_test 4    
      
    end

    it 'should generate then solve' do
      sha256 = SHA256Puzzle.new({:iterations => 1000, :threads => 4, :encryption => :aes_256_gcm})
      puzzle = sha256.generate
      key = sha256.key
      result = sha256.solve(puzzle)
      result.should == key
    end

    it 'should take longer to solve then generate' do
      sha256 = SHA256Puzzle.new({:iterations => 100000, :threads => 4, :encryption => :aes_256_gcm})
      start_gen = Time.now
      puzzle = sha256.generate
      puzzle_gen = Time.now - start_gen

      start_solve = Time.now
      key = sha256.solve puzzle
      puzzle_solve = Time.now - start_solve

      puts "Generation time: #{puzzle_gen}"
      puts "Solve time: #{puzzle_solve}"

      puzzle_solve.should > puzzle_gen  

    end

    it 'should solve the puzzle' do
      extend Utils
      puzzle = {:seed => [known_answers[:input]]}
      solver = SHA256Puzzle.new({:iterations => 1, :threads => 1, :encryption => :aes_256_gcm})
      result = solver.solve(puzzle)
      known_answers[:output].should == bin_to_hex(solver.solve(puzzle))
    end

  end

  private 
  def known_answer_test thread_count
    extend Utils
    seed = Array.new
    thread_count.times { seed << known_answers[:input]}
    generator = SHA256Puzzle.new({:iterations => 1, :threads => thread_count, :encryption => :aes_256_gcm})
    puzzle = generator.generate(seed)
    puzzle.should == generator.puzzle
    (0..thread_count).each do |i|
      known_answers[:input].should == puzzle[:seed][i-1]
    end
    known_answers[:output].should == bin_to_hex(generator.key)
  end
end
