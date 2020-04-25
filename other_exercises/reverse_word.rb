# You are given a str which contains a set of words and punctuation characters.
# You need to reverse the word in the string without touching the punctuation characters.
# You do need to trim any whitespace within the string and you can assume the string has
# no leading or trailing whitespaces.
#

# O(k*n)
PUNCTUATION = [',', ';', '.', ' ']
def reverse_word(s)
  word_stack = []
  ans_stack = []

  # O(k*n)
  word = ''
  s.each_char do |c|
    if !PUNCTUATION.include?(c)
      word += c
    else
      if word.length > 0
        word_stack << word
        ans_stack << '#'
        word = ''
      end
      ans_stack << c
    end
  end
  if word.length > 0
    ans_stack << '#'
    word_stack << word
  end

  # O(n)
  ans_stack.map do |w|
    if w == '#'
      word_stack.pop
    else
      w
    end
  end.join
end


s = "this, exercise is pretty nice. too"
p reverse_word(s)
# too, nice pretty is exercise. this


