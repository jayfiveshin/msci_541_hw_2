require 'zlib'
require 'stemmify'

def read_gzip(file_name)
  Zlib::GzipReader.open(file_name).read
end

def tokenize(string)
  term  = ""
  terms = []
  middle_of_tag = false
  string.downcase.split("").each { |char| 
    if char.match(">")
      middle_of_tag = false
    elsif middle_of_tag
      next
    elsif char.match("<")
      middle_of_tag = true
      next
    elsif char.match(/[a-z0-9]/)
      term += char
    elsif term.empty?
      next
    else
      terms << term.stem
      term = ""
    end
  }
  terms
end

def calculate_tf(terms)
  tf = {}
  terms.each { |term|
    if tf[term].nil?
      tf[term] = 1
    else
      tf[term] += 1
    end
  }
  tf
end

def calculate_df(dictionary, file_name)
  df = {}
  doc = ""
  doc_count = 0
  middle_of_doc = false
  Zlib::GzipReader.open(file_name) { |string|
    string.each { |line|
      line.downcase!
      if line.match("</doc>")
        doc << line
        dictionary.each { |term|
          if doc.match(term)
            if df[term].nil?
              df[term] = 1
            else
              df[term] += 1
            end
          end
        }
        middle_of_doc = false
        doc = ""
        next
      elsif middle_of_doc
        doc << line
        next
      elsif line.match("<doc>")
        doc_count += 1
        print "\r\e[0K#{doc_count} docs processed..."
        doc << line
        middle_of_doc = true
        next
      end
    }
  }
  print "\n"
  df
end

def read_per_doc(file_name)
  t1 = Time.now
  docno = ""
  docno_array = []
  Zlib::GzipReader.open(file_name) { |string|
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
  puts "\r\e[0K#{t2 - t1}"
  docno_array
end

def calculate_tfidf(tf, df)
  tfidf = {}
  tf.each { |term, frequency|
    tfidf[term] = (tf[term].to_f / df[term].to_f).round(3)
  }
  tfidf
end

def build_dictionary(tf_hash)
  dictionary = tf_hash.keys
end

def sort_by_frequency(tf_hash)
  Hash[tf_hash.sort_by { |term, frequency| -1*frequency}]
end

def display_table(tf_hash)
  rank = 1
  puts "RANK\tTERM\t\tFREQUENCY"
  sort_by_frequency(tf_hash).each { |term, frequency|
    if rank > 20
      break
    end
    if term.length > 7
      puts "#{rank}\t#{term}\t#{frequency}"
    else
      puts "#{rank}\t#{term}\t\t#{frequency}"
    end
    rank += 1
  }
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
