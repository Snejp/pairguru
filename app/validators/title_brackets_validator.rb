class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    unless self.balanced?(record.title)
      record.errors[:title] << 'Brackets in title does not validate'
    end
  end

  def balanced? string
    # check for empty brackets
    return false if string =~ /(\[\]|\(\)|\{\})/

    pairs = { '{' => '}', '[' => ']', '(' => ')' }
    stack = []
    
    string.chars do |bracket|
      unless bracket =~ /[^\[\]\(\)\{\}]/
        if expectation = pairs[bracket]
          stack << expectation
        else
          return false unless stack.pop == bracket
        end
      end
    end

    stack.empty?
  end
end