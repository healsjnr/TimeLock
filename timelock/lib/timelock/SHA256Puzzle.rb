$:.unshift File.dirname(__FILE__)
require 'openssl'

class SHA256Puzzle < Puzzle

  def generate(seed = OpenSSL::Random.random_bytes(32))
    # seed actually needs to be passed in as an array. If not provided we need to 
    # we need to creat seeds for each thread generating data. 
    @puzzle[:seed] = Array.new([seed])
    sha256 = OpenSSL::Digest::SHA256.new
    @key = do_hash_iterations @params[:iterations], @puzzle[:seed][0]
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