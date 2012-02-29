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

  def display
    self.sort.each do |k,v|
      unless k.length > 6
        puts "#{k}:\t\t#{v}"
      else
        puts "#{k}:\t#{v}"
      end
    end
  end
end
