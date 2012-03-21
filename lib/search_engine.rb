require 'zlib'
require 'stemmify'
load 'lib/string.rb'
load 'lib/hash.rb'
load 'lib/array.rb'

# use to read gzipped files only
def get_data(filename)
  Zlib::GzipReader.open(filename)
end

def read_data(filename)
  Zlib::GzipReader.open(filename).read
end

def build_df(dictionary, filename)
  df_table  = Hash.new # what this method returns
  document  = String.new # used to store one document at a time
  inside    = false
  get_data(filename).each do |line|
    line.downcase!
    if inside and line.match("</doc>")
      document << line
      dictionary.each do |term|
        document.match(term) { |m| df_table[m.to_s] = df_table[m.to_s].to_i + 1 }
      end
      inside = false
      document.clear
    elsif inside and !line.match("</doc>")
      document << line
    elsif !inside and line.match("<doc>")
      document << line
      inside = true
    end
  end
  return df_table
end

def build_tfidf(tf_table, df_table)
  tfidf_table = Hash.new
  tf_table.each { |term, frequency|
    tfidf_table[term] = (tf_table[term].to_f / df_table[term].to_f).round(3)
  }
  return tfidf_table
end

def sort_by_frequency(tf_hash)
  Hash[tf_hash.sort_by { |term, frequency| -1*frequency}]
end

def display_tfidf_table(tf, tfidf)
  rank = 1
  puts "RANK\tTERM\t\tTF\tTFIDF"
  sort_by_frequency(tfidf).each { |term, frequency|
    if rank > 20
      break
    end
    if term.length > 7
      puts "#{rank}\t#{term}\t#{tf[term]}\t#{frequency}"
    else
      puts "#{rank}\t#{term}\t\t#{tf[term]}\t#{frequency}"
    end
    rank += 1
  }
end

def get_docno(filename)
  t1 = Time.now
  docno = ""
  docno_array = []
  Zlib::GzipReader.open(filename) { |string|
    string.each { |line|
      line.downcase!
      if line.match "<docno>"
        docno = tokenize(line)
        docno = "#{docno[0]} #{docno[1]}"
        print "\r\e[0K#{docno}"
        docno_array << docno
      end
    }
  }
  t2 = Time.now
  puts "\r\e[0KGetting doc_no #{t2 - t1} seconds"
  docno_array
end

def write_hash(h)
  open("index.txt", "w") { |f|
    f.write h
  }
end

def invert(data)
  # local variable declarations
  temp  = {}
  index = {}
  doc   = ""
  docid = 0 # arbitrary number
  mid_of_text = false
  docno = ""
  docno_h = {}
  doc_count = 0
  doc_count_h = {}
  data.each_with_index do |line,l_count|
    if line.match("<DOCNO>")
      docno = line.tokenize[1]
    elsif line.match("<DOCID>")
      docid = line.tokenize[1].to_i
    elsif line.match("</DOC>")
      temp.each do |word,count|
        doc_count += count
        if index[word].nil?
          index[word] = {docid => count} # initialize
        else
          index[word][docid] = count # increment
        end
      end
      doc_count_h[docid] = doc_count
      doc_count = 0
      temp.clear
    elsif line.match("<TEXT>")
      mid_of_text = true
    elsif line.match("</TEXT>")
      mid_of_text = false
    elsif mid_of_text
      line.tokenize.each do |token|
        temp[token] = temp[token].to_i + 1 # if temp[token] is nil, temp[token].to_i is 0
      end
    end
    docno_h[docid] = docno
    print "\r\e[0K#{(l_count.to_f/99933.to_f).round(2)}"
  end
  write_to_file(index,"index.txt")
  write_to_file(docno_h, "docno_h.txt")
  write_to_file(doc_count_h, "doc_count_h.txt")
end

def index_read(i)
  i.each do |k,v|
    puts "#{k}: #{v}"
  end
end

def write_to_file(i,name)
  serialized_object = YAML::dump(i)
  File.open(name, "w") { |f|
    f.write serialized_object
  }
end

def read_from_file(f)
  File.open(f, "r") { |f|
    YAML::load(f.read)
  }
end
