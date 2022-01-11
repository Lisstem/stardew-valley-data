# frozen_string_literal: true

# Monkey patch String class
class String
  def underscore
    self.split(' ').join('_')
  end

  def or(string)
    "#{self} or #{string}"
  end
end
