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
