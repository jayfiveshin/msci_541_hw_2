load 'lib/search_engine.rb'
article   = "data/chosen_article.dat.gz"
data      = "data/latimes.dat.gz"
data_1    = "data/latimes_1.dat.gz"
data_2    = "data/latimes_2.dat.gz"
data_810  = "data/latimes_810.dat.gz"
stopwords = open("stopwords").read
t1 = Time.now
col = read_data(data_1)
puts invert(col)
# read_data(data)
# tf_table = read_data(article).tokenize.build_tf
# tf_table.display_table
# dictionary = tf_table.keys
# df_table = build_df(dictionary, data)
# tfidf_table = build_tfidf(tf_table, df_table)
# display_tfidf_table(tf_table, tfidf_table)
# write_to_file
# read_from_file
t2 = Time.now
puts "\nTotal processing time was #{t2 - t1} seconds."
