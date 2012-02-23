require 'stemmify'

class Tokenizer
  def tokenize(string)
    # NOTE Try using switches instead
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
end

