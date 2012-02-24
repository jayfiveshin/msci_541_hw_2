require 'stemmify'

class Tokenizer
  def initialize
  end

  def tokenize(str)
    term  = ""
    terms = []
    mid_of_tag = false
    str.downcase.split("").each { |char| 
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

