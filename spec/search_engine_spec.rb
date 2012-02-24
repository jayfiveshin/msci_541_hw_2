load 'lib/search_engine.rb'

describe SearchEngine do
  before(:each) do
    @se = SearchEngine.new
    @gzipped_file  = "data/latimes_1.dat.gz"
    @unzipped_file = "data/latimes_1.dat"
    @dictionary = ["korean", "person", "gesture", "friendly", "joonha", "shin"]
  end

  describe "read_data" do
    it "should have read_data method" do
      @se.read_data(@gzipped_file).should be_true
    end

    it "should be able to read gzipped data" do
      @se.read_data(@gzipped_file).should == open(@unzipped_file).read
    end
  end

  describe "build_df" do
    it "should have build_df method" do
      @se.build_df(@dictionary, @gzipped_file).should be_true
    end

    it "should return a hash table" do
      @se.build_df(@dictionary, @gzipped_file).should be_an_instance_of(Hash)
    end

    it "should return document frequency table" do
      @se.build_df(@dictionary, @gzipped_file).should eq({"person" => 1, "shin" => 2})
    end
  end
end
