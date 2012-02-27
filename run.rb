load 'lib/search_engine.rb'
se = SearchEngine.new
article = "data/chosen_article.dat.gz"
data = "data/latimes_810.dat.gz"
data_2 = "data/latimes_2.dat.gz"
stopwords = open("stopwords_1").read
t1 = Time.now
puts se.invert(se.read_data(data_2))
# se.read_data(data)
# tf_table = se.read_data(article).tokenize.build_tf
# tf_table.display_table
# dictionary = tf_table.keys
# df_table = se.build_df(dictionary, data)
# tfidf_table = se.build_tfidf(tf_table, df_table)
# se.display_tfidf_table(tf_table, tfidf_table)
# se.write_to_file
# se.read_from_file
t2 = Time.now
puts "\nTotal processing time was #{t2 - t1} seconds."
