class Hash
  def build_dictionary
    self.keys
  end

  def display_table
    se = SearchEngine.new
    rank = 1
    puts "RANK\tTERM\t\tFREQUENCY"
    se.sort_by_frequency(self).each { |term, frequency|
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
