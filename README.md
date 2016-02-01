TimeLock
========

Gem for create time lock puzzles inspired by the following article: http://www.gwern.net/Self-decrypting%20files

The aim is to provide an gem that allows the creation and solving of time lock puzzles using:
 
 * Hashing (Time Puzzle in the Random Oracle) - Use a random seed that is then used as the input to the hash function and repeat. The number of hashes executed defines workload to solve the puzzle. The creation is expediated by executing this process in many parralel threads. Once the requisite numbers hashes are exeecuted, the output of thread 1 is used to encrypt the seed for thread 2 and so. This allows the puzzle to be created in parralel time but, requires it to be solved linearly. (In Progress)
 * Scrypt - the same as the above but using Scrypt as the hash function. The advantage is the scrypt is designed to be both CPU and Memory bound. This adds some more level of protection against CPU speed up. (To Do)
 * Squaring modulo n - based on the paper by Rivest and Shamir, this requires the key be calculated by solving 2 ^ 2 ^ t modulo n. The advantage of this approach is that if the composite primes p and q (which make up n) are known, then the result can be found very quickly. This means the work to create the puzzles is drastically smaller than the work to solve. The downside is that it relies on the fact that prime factorisation is hard, if this ceases to be the case the puzzle is trivial to unlock. (To Do)

Very much still in progress. 

### Development

Requires libxml2 (for nokogiri)

    $ brew install libxml2

Test

    $ bundle install
    $ bundle exec rake spec
