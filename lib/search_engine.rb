require 'zlib'
require 'stemmify'

class SearchEngine
  def read_gzip(file_name)
    Zlib::GzipReader.open(file_name).read
  end

  def build_df(dictionary, file_name)
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

  def get_length(file_name)
    t1 = Time.now
    doc_count = 0
    doc = ""
    middle_of_doc = false
    Zlib::GzipReader.open(file_name) { |string|
      string.each { |line|
        line.downcase!
        if line.match("</doc>")
          doc << line
          words = doc.split
          print "\r\e[0K#{words.length}"
          middle_of_doc = false
          doc = ""
          next
        elsif middle_of_doc
          doc << line
          next
        elsif line.match("<doc>")
          doc_count += 1
          # print "\r\e[0K#{doc_count} docs processed..."
          doc << line
          middle_of_doc = true
          next
        end
      }
    }
    t2 = Time.now
    print "\r\e[0KGetting doc_length #{t2 - t1} seconds"
  end

  def get_docno(file_name)
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
    puts "\r\e[0KGetting doc_no #{t2 - t1} seconds"
    docno_array
  end

  def build_tfidf(tf, df)
    tfidf = {}
    tf.each { |term, frequency|
      tfidf[term] = (tf[term].to_f / df[term].to_f).round(3)
    }
    tfidf
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

  def write_to_file
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

  def read_from_file
    mid_of_doc = false
    hash       = Hash.new
    docno      = String.new
    tokenizer  = Tokenizer.new
    open("testing.txt").each do |line|
      line.downcase!
      if line.match("<doc>")
        mid_of_doc = true
      elsif mid_of_doc and line.match("<docno>")
        docno = tokenizer.tokenize(line).join
        hash[docno] = {}
      elsif mid_of_doc and line.match("<index>")
        next
      elsif mid_of_doc and line.match("</doc>")
        mid_of_doc = false
      elsif mid_of_doc
        terms = tokenizer.tokenize(line)
        hash[docno][terms[0]] = terms[1]
      end
    end
    puts hash
  end

  def invert(str)
    @tokenizer.tokenize(str).each { |word|
      @hash[word] = @hash[word].to_i + 1
    }
    @hash
  end

  def get_docno(str)
    docno = String.new
    str.downcase!
    if str.match "<docno>"
      docno = @tokenizer.tokenize(str)[0]
      # docno = "#{docno[0]} #{docno[1]}"
      # print "\r\e[0K#{docno}"
      @hash[docno] = {}
    end
    @hash
  end
end

class String
  def tokenize
    term  = ""
    terms = []
    mid_of_tag = false
    self.downcase.split("").each { |char| 
      if char === '>'
        mid_of_tag = false
      elsif mid_of_tag
        next
      elsif char === '<'
        mid_of_tag = true
      elsif char.match(/[a-z0-9]/)
        term += char
      elsif term.empty?
        next
      else
        terms << term.stem
        term.clear
      end
    }
    if term.empty?
      terms
    else
      terms << term.stem
    end
  end
end

class Array
  def build_tf
    tf = {}
    self.each { |term|
      if tf[term].nil?
        tf[term] = 1
      else
        tf[term] += 1
      end
    }
    tf
  end
end

class Hash
  def build_dictionary
    self.keys
  end

  def display_table
    rank = 1
    puts "RANK\tTERM\t\tFREQUENCY"
    sort_by_frequency(self).each { |term, frequency|
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
end
