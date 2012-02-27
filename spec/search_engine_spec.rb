load 'lib/search_engine.rb'

describe SearchEngine do
  before(:each) do
    @se = SearchEngine.new
    @gzipped_file  = "data/latimes_810.dat.gz"
    @unzipped_file = "data/latimes_810.dat"
    @dictionary = ["apple", "tree"]
    @tf_table = {"hash" => 1, "table" => 2, "from" => 3, "me" => 4}
    @df_table = {"hash" => 4, "table" => 1, "from" => 6, "me" => 8}
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
      @se.build_df(@dictionary, @gzipped_file).should eq( {"apple" => 13, "tree" => 110} )
    end
  end

  describe "build_tfidf" do
    it "should have build_tfidf method" do
      @se.build_tfidf(@tf_table, @df_table).should be_true
    end

    it "should return the right tfidf table" do
      @se.build_tfidf(@tf_table, @df_table).should eq( {"hash" => 0.25, "table" => 2.0, "from" => 0.5, "me" => 0.5} )
    end
  end

  describe "sort_by_frequency" do
    it "should sort hash" do
      @se.sort_by_frequency(@tf_table).should be_true
    end

    it "should sort based on frequency" do
      @se.sort_by_frequency(@tf_table).should eq({"me" => 4, "from" => 3, "table" => 2, "hash" => 1})
    end
  end

  describe "invert" do


  end

  describe "tokenize" do

  end

  describe "build_tf" do

  end

  describe "build_dictionary" do

  end

  describe "display_table" do

  end

end
