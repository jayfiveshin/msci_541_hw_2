load 'lib/tokenizer.rb'

describe Tokenizer do
  before(:each) do
    @tokenizer = Tokenizer.new
  end

  it "should downcase" do
    string = "Joonha"
    @tokenizer.tokenize(string).should eq(["joonha"])
  end

  it "should tokenize a sentence" do
    string = "Joonha is here"
    @tokenizer.tokenize(string).should eq(["joonha", "is", "here"])
  end

  it "should stemmify" do
    string = "run runs running"
    @tokenizer.tokenize(string).should eq(["run", "run", "run"])
  end
end
