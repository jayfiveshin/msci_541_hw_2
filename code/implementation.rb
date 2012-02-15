load 'code/methods.rb'

article = read_gzip("data/chosen_article.txt.gz")
terms = tokenize(article)
tf = calculate_tf(terms)
display_table(tf)
dictionary = build_dictionary(tf)
df = calculate_df(dictionary, "data/latimes.dat.gz")
tfidf = calculate_tfidf(tf, df)
display_tfidf_table(tf, tfidf)
