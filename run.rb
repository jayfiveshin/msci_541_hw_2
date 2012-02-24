load 'lib/search_engine.rb'

@se = SearchEngine.new
chosen_article = "data/chosen_article.dat.gz"
collection = "data/latimes_810.dat.gz"

t1 = Time.now

puts "Building TF Hash Table..."
tf_hash = @se.read_gzip(chosen_article).tokenize.build_tf

puts "\nTF Table"
tf_hash.display_table

puts "\nBuilding dictionary..."
dictionary = tf_hash.build_dictionary

puts "\nBuilding DF Table, please be patient..."
df_hash = @se.build_df(dictionary, collection)

puts "\nBuilding TFIDF Table..."
tfidf_hash = @se.build_tfidf(tf_hash, df_hash)

puts "\nTFIDF Table"
@se.display_tfidf_table(tf_hash, tfidf_hash)

t2 = Time.now
puts "\nTotal processing time was #{t2 - t1} seconds."

@se.write_to_file
@se.read_from_file
