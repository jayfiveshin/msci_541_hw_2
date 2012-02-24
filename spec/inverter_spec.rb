require 'zlib'
load 'lib/inverter.rb'

describe Inverter do
  before (:each) do
    @inverter     = Inverter.new
    @latimes_1    = Zlib::GzipReader.open('data/latimes_1.dat.gz').read
    @latimes_2    = Zlib::GzipReader.open('data/latimes_2.dat.gz').read
    @latimes_810  = Zlib::GzipReader.open('data/latimes_810.dat.gz').read
  end

  it "should return the word and its count in the document" do
    doc = "word"
    @inverter.invert(doc).should eq({"word" => 1})
  end

  it "should return all words and its count in the document" do
    doc = "I am Joonha Shin, I am Joonha Shin."
    @inverter.invert(doc).should eq({"am" => 2,"i" => 2, "joonha" => 2, "shin" => 2})
  end

  it "should be able to identify DOCNO" do
    doc = "<DOCNO>100</DOCNO>"
    @inverter.get_docno(doc).should eq( {"100" => {} } )
  end

  it "should be able to identify multiple DOCNOs" do
    doc ="<DOCNO>100</DOCNO>
    <DOCNO>101</DOCNO>"
    @inverter.get_docno(doc).should eq( { "100" => {}, "101" => {} } )
  end
  # it "should identify multiple documents using DOCNO" do
  #   doc = "<DOC>
  #   <DOCNO>100</DOCNO>
  #   This is the first document
  #   </DOC>
  #   <DOC>
  #   <DOCNO>101</DOCNO>
  #   This is the second document
  #   </DOC>"
  #   @inverter.invert(doc).should eq({"100" => {"thi" => 1, "is" => 1, "the" => 1, "first" => 1, "document" => 1}, "101" => {"this" => 1, "is" => 1, "the" => 1, "second" => 1, "document" => 1}})
  # end
end
