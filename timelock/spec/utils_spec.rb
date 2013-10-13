$:.unshift File.dirname(__FILE__) + "../lib"
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'timelock/utils.rb'

describe "Utils testing" do
  
  let(:tests) { [[0,0,0,0], [0x01, 0x01, 0x01, 0x01], [0x10, 0x10], [1,1,1,1], [0xff, 0xff], [0x10, 0x01]] }

  it 'should convert to hex and back successfully' do
    extend Utils

    tests.each do |t|
      str = t.pack('c*')
      str.should == hex_to_bin(bin_to_hex(str))
    end

  end
  
end