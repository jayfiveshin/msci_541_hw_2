load 'lib/tokenizer.rb'

class Inverter
  def initialize
    @tokenizer = Tokenizer.new
    @hash = Hash.new
  end

  def invert(str)
    @tokenizer.tokenize(str).each { |word|
      @hash[word] = @hash[word].to_i + 1
    }
    @hash
  end

  def get_docno(str)
    docno = String.new
    str.downcase!
    if str.match "<docno>"
      docno = @tokenizer.tokenize(str)[0]
      # docno = "#{docno[0]} #{docno[1]}"
      # print "\r\e[0K#{docno}"
      @hash[docno] = {}
    end
    @hash
  end
end

