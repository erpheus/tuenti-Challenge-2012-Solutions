# Challenge3: The evil trader
# Author: José Antonio Porras

def resolver(array,nivel)
  j = array.length
  tope = array[nivel][1]
  while(array[j-1][1]<tope) do
    j-=1
  end
  [(array[j-1][0]-array[nivel][0]).abs,array[nivel][1],array[j-1][1]]
end

# MAIN PROGRAM
w = []
STDIN.each_with_index{|l,idx|
  w<<[l.strip.to_i,idx]
}

m = w
n = m.sort

sol = []
(Math.log(n.length)).floor.to_i.times{|x|
  sol << resolver(n,x)
}
s = sol.sort.last
puts "#{s[1]*100} #{s[2]*100} #{s[0]}"
