class String
  STOPWORDS = open("stopwords").read
  def tokenize
    terms = []
    self.downcase.split(/[^a-z_\-<>\/0-9]/).each do |t|
      unless STOPWORDS.match(t)
        terms << t
      end
    end
    terms
    # OLD METHOD
    # term  = String.new
    # terms = Array.new
    # mid_of_tag = false
    # self.downcase.split("").each { |char| 
    #   if char === '>'
    #     mid_of_tag = false
    #   elsif mid_of_tag
    #     next
    #   elsif char === '<'
    #     mid_of_tag = true
    #   elsif char.match(/[a-z0-9]/)
    #     term += char
    #   elsif term.empty?
    #     next
    #   else
    #     unless stopwords.match(term.stem)
    #       terms << term.stem
    #     end
    #     term.clear
    #   end
    # }
    # if term.empty?
    #   terms
    # else
    #   unless stopwords.match(term.stem)
    #     terms << term.stem
    #   end
    # end
  end
end
