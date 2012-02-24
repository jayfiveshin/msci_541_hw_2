load 'lib/search_engine.rb'

describe SearchEngine do
  before(:each) do
    @se = SearchEngine.new
    @file_name = "data/latimes_1.dat.gz"
  end

  it "should be able to read gzipped data" do
    @se.read_data(@file_name).should be_true
  end
end
