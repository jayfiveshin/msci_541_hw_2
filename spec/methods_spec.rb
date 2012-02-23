load 'code/methods.rb'

describe Tokenizer do 
  it "should tokenize string" do
    string = "Joonha Shin was here!"
    tokenizer = Tokenizer.new
    tokenizer.tokenize(string).should eq(["joonha", "shin", "wa", "here"])
  end
end
