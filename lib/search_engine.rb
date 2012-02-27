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

def write_hash
  hash = {"la10189-0001" => {"joonha" => 1, "shin" => 1}, "la10189-0002" => {"jake" => 2, "nolan" => 1}}
  open("testing.txt", "w") { |f|
    hash.each { |k, v|
      f.write "<DOC>\n"
      f.write "<DOCNO>#{k}</DOCNO>\n"
      f.write "<INDEX>\n"
      v.each { |k, v|
        f.write "#{k}=#{v}\n"
      }
      f.write "</INDEX>\n"
      f.write "</DOC>\n"
    }
  }
end

def read_hash
  mid_of_doc = false
  hash       = Hash.new
  docno      = String.new
  open("testing.txt").each do |line|
    line.downcase!
    if line.match("<doc>")
      mid_of_doc = true
    elsif mid_of_doc and line.match("<docno>")
      docno = line.tokenize.join
      hash[docno] = {}
    elsif mid_of_doc and line.match("<index>")
      next
    elsif mid_of_doc and line.match("</doc>")
      mid_of_doc = false
    elsif mid_of_doc
      terms = line.tokenize
      hash[docno][terms[0]] = terms[1]
    end
  end
  puts hash
end

def invert(str)
  str.tokenize

end
