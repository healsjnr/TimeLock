$:.unshift File.dirname(__FILE__)
require 'openssl'

class SHA256Puzzle < Puzzle

	# Probably need to refactor this so that threads is passed into the generate method. 
	# as it's not needed outside of generate

	# Also need to add a new param value for the encryption algorithm used to encrypt successive hashed. 

  def generate(seed=nil)
    
    threads = []
    @params[:threads].times do |i|
    	threads[i] = Thread.new {
    		Thread.current[:seed] = seed[i] || OpenSSL::Random.random_bytes(32)
    		Thread.current[:key] = do_hash_iterations @params[:iterations], Thread.current[:seed]
    	}
    end

    @puzzle[:seed] = Array.new

    # shouldn't really be storing key on puzzle. It should be a separate attribute.
    @puzzle[:key] = Array.new

    threads.each_with_index do |t, i| 
    	t.join
    	@puzzle[:seed][i] = t[:seed]
    	@puzzle[:key][i] = t[:key]
    end

    # do encryption of each key

    @puzzle
   end

  def solve(puzzle)
    @puzzle = puzzle
    sha256 = OpenSSL::Digest::SHA256.new
    @key = do_hash_iterations @params[:iterations], @puzzle[:seed][0]
  end

  private
  def do_hash_iterations number, seed
    sha256 = OpenSSL::Digest::SHA256.new
    (1..number).inject(seed) do |prev, _|
      sha256.reset
      sha256 << prev
      sha256.digest
    end
  end
end
