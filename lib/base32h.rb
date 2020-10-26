##
# This module provides Base32H encoding and decoding functions.
module Base32H
  VERSION = "0.1.0"
  
  extend self

  ##
  # The complete list of Base32H digits, as an array of strings.  The
  # index of the array is the numeric value of the digit(s) in the
  # string at that index.  The first character in each string is the
  # "canonical" digit (i.e. the one that Base32H-conformant encoders
  # *must* emit for that value); all other characters (if present) are
  # "aliases" (i.e. alternate forms of that digit that
  # Base32H-conformant decoders *must* accept and correctly decode to
  # that value).
  #
  # For example, +digits[27]+ returns +'VvUu'+, meaning that the
  # "canonical" digit of value 27 is +V+, and that +v+, +U+, and +u+
  # are all "aliases" of that canonical digit and decode to a value of
  # 27.
  #
  # @return [Array] the full list of digits
  def digits
    ['0Oo',
     '1Ii',
     '2',
     '3',
     '4',
     '5Ss',
     '6',
     '7',
     '8',
     '9',
     'Aa',
     'Bb',
     'Cc',
     'Dd',
     'Ee',
     'Ff',
     'Gg',
     'Hh',
     'Jj',
     'Kk',
     'Ll',
     'Mm',
     'Nn',
     'Pp',
     'Qq',
     'Rr',
     'Tt',
     'VvUu',
     'Ww',
     'Xx',
     'Yy',
     'Zz']
  end

  ##
  # Encodes an integer between 0 and 31 (inclusive) to its Base32H
  # representation.  Returns +nil+ for input values outside that
  # range.
  #
  # @param d [Integer] the integer value of the requested digit
  #
  # @return [String, NilClass] the resulting digit
  def encode_digit(d)
    d = d.to_i
    return nil unless (0..31).include? d
    digits[d][0]
  end

  ##
  # Encodes an integer to its Base32H representation.
  #
  # @param int [Integer] the integer to encode
  #
  # @return [String] the encoded number
  def encode(int)
    rem = int.to_i.abs
    out = []
    return '0' if rem == 0
    while rem > 0 do
      out.unshift(encode_digit(rem % 32))
      rem /= 32
    end
    out.join ''
  end

  ##
  # Encodes a (binary) string to its Base32H representation.
  #
  # @param bin [String] the string/binary to encode
  #
  # @return [String] the encoded binary
  def encode_bin(bin)
    data = bin.unpack('C*')
    extra = data.length % 5
    data = ([0] * (5 - extra)) + data if extra > 0
    out = []
    data.each_slice(5) do |s|
      chunk = bytes_to_u40 s
      out.push encode(chunk).rjust(8, '0')
    end
    out.join ''
  end

  ##
  # Decodes a single Base32H digit to its integer representation.
  # Returns nil if the input is not a Base32H digit.
  #
  # @param d [String] the digit to decode
  #
  # @return [Integer] the digit's value
  def decode_digit(d)
    d = d.to_s
    digits.find_index {|i| i.include? d}
  end

  ##
  # Decodes a Base32H number to its integer representation.
  #
  # @param str [String] the number to decode
  #
  # @return [Integer] the decoded integer
  def decode(str)
    res = str.to_s.chars.reverse.reduce({acc: 0, exp: 0}) do |state, char|
      digit = decode_digit(char)
      if digit.nil?
        state
      else
        {acc: state[:acc] + (digit * 32**state[:exp]),
         exp: state[:exp] + 1}
      end
    end
    res[:acc]
  end

  ##
  # Decodes a Base32H binary into a string of packed unsigned bytes.
  #
  # @param str [String] the binary to decode
  #
  # @return [String] the decoded binary
  def decode_bin(str)
    data = str.chars.reject {|c| decode_digit(c).nil?}
    extra = data.length % 8
    data = (['0'] * (8 - extra)) + data if extra > 0
    out = []
    data.each_slice(8) do |s|
      chunk = u40_to_bytes decode(s.join '')
      out += chunk
    end
    out.pack('C*')
  end

  private

  def u40_to_bytes(int)
    rem = int.to_i.abs
    out = []
    while rem > 0 do
      out.unshift(rem % 256)
      rem /= 256
    end
    pad = 5 - out.length
    out = ([0] * pad) + out if pad > 0
    out
  end

  def bytes_to_u40(bytes)
    bytes.reverse.reduce({acc:0,exp:0}) do |s,b|
      {acc: s[:acc] + (b * 2**(8*s[:exp])),
       exp: s[:exp] + 1}
    end[:acc]
  end
end

class Integer
  ##
  # Encodes the integer to its Base32H numeric representation.
  #
  # @return [String] the integer's Base32H representation
  def to_base32h
    Base32H.encode(self)
  end
end

class String
  ##
  # Encodes the string to its Base32H binary representation.
  #
  # @return [String] the string's Base32H representation
  def to_base32h
    Base32H.encode_bin(self)
  end
end
