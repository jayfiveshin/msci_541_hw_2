load 'lib/search_engine.rb'

@se = SearchEngine.new
data = "data/latimes_810.dat.gz"
t1 = Time.now
puts @se.read_data(data)
@se.write_to_file
@se.read_from_file
t2 = Time.now
puts "\nTotal processing time was #{t2 - t1} seconds."
