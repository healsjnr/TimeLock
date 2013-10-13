module Utils
	def bin_to_hex(s)
  	s.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
	end

	def hex_to_bin(s)
 		s.scan(/../).map { |x| x.hex.chr }.join
	end

end
