require 'openssl'

class SHA256Puzzle < Puzzle

  ENCRYPTION_ALGS = [:aes_256_gcm]

  def initialize(params)
    raise "Invalid value for :encryption #{params[:encryption].nil? ? 'nil' : params[:encryption]}." unless ENCRYPTION_ALGS.include? params[:encryption]
    raise "Invalid value of :iterations #{params[:iterations].nil? ? 'nil' : params[:iterations]}." unless params[:iterations].is_a? Fixnum
    params[:threads] ||= 1
    super
  end

  # Also need to add a new param value for the encryption algorithm used to encrypt successive hashed. 
  def generate(seed=nil)
    
    # Generate the number of theads required. Each generates a seed and then hashes it the
    # required number iterations
    threads = []
    @params[:threads].times do |i|
      threads[i] = Thread.new {
        Thread.current[:seed] = seed.nil? ? OpenSSL::Random.random_bytes(32) : seed[i]
        Thread.current[:result] = do_hash_iterations @params[:iterations], Thread.current[:seed]
      }
    end

    @puzzle[:seed] = []
    results = []

    threads.each_with_index do |t, i| 
      t.join
      # we use the previous threads result to encrypt the current seed. 
      key = i != 0 ? results[i-1] : nil
      @puzzle[:seed][i] = encrypt t[:seed], key
      results[i] = t[:result]
    end

    # The key is the final result. 
    @key = results.last
    @puzzle
  end

  # Solve a puzzle
  # Puzzle should consist of
  #   :seed Array List of seeds. The first seed is in the clear. The remaining seeds
  #               are encrypted with the result of hashing the previous seed @params[:iteraiton] times.
  def solve(puzzle)
    puzzle[:seed].inject(nil) do |prev, s|
      seed = decrypt s, prev unless prev = nil
      do_hash_iterations @params[:iterations], seed
    end
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

  def encrypt data, key
    data
  end

  def decrypt data, key
    data
  end
end