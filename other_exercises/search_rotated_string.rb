def same?(s1, s2)
  return false if s1.length != s2.length

  s2.chars.each_with_index do |c, idx|
    return true if s1[0] == c && search_rotation(s1, s2, idx)
  end
  false
end

def search_rotation(s1, s2, start)
  i = 0
  j = start
  s2.length.times do
    return false if s1[i] != s2[j]

    i += 1
    j = (j + 1) % s2.length
  end
  true
end

s1 = 'abcde'
s2 = 'cdeab'
p same?(s1, s2)
