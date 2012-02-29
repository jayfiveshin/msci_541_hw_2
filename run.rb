load 'lib/search_engine.rb'
article   = "data/chosen_article.dat.gz"
data      = "data/latimes.dat.gz"
data_1    = "data/latimes_1.dat.gz"
data_3    = "data/latimes_3.dat.gz"
data_810  = "data/latimes_810.dat.gz"
stopwords = open("stopwords").read
t1 = Time.now
col = read_data(data_810)
invert(col)
t2 = Time.now
puts "\nTotal processing time was #{t2 - t1} seconds."
