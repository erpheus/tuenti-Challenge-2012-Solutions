require 'pp'

# Challenge 7: The "secure" password
# Coded by José Antonio Porras 



input = []

#f = File.open("entrada.txt","r")
STDIN.each_line{|line|
  input << line.strip
  }



=begin
input = %w(
2Ad
12c
2Ac
2Bc
1cd
1xZ
1dx
BdZ
)
=end

def m_assoc(array,c)
  v = array
  asoc = []
  while !v.assoc(c).nil?
    r = v.assoc(c)
    asoc << r[1]
    v.delete(r)    
  end
  return asoc
end  

chars = []
input.each{|e|
  e.each_char{|c|
    chars << [c,e.index(c)]
  }
}
nivel = []

chars.sort.each{|c| 
  nivel << {c[0]=>m_assoc(chars.sort,c[0])}
  }

nivel.uniq.sort{|a,b| b.length<=>a.length}






er = []
input.each{|v|
  str = "(#{v[0]}.*#{v[1]}.*#{v[2]})"
    er << Regexp.new(str)
  }  


def ordena_array(vector,entrada)
  orden = []
  entrada.each{|e|
    vector.permutation(2).each{|perm|
      if e.include?(perm.join)
        orden << perm
      end
    }
  }
  return orden
end

# entradas x posiciones
table = Array.new(input.length)

input.each_with_index{|d,index|
  table[index] = Array.new(8)
  8.times{|position| table[index][position] = [] }
  8.times{|position|
    (0..5).each{|i|
      table[0][position+i] << d[0] if position+i <6
    }
    (1..6).each{|i|
      table[0][position+i] << d[1] if position+i <7
    }
    (2..7).each{|i|
      table[0][position+i] << d[2] if position+i <8
    }  
  }
}

orden=[]
r = table[0].each.map{|e| e.uniq}
8.times{|c|
  orden << ordena_array(r[c],input)
}

#pp ady = orden.flatten(1).uniq.sort


n1 = r[0].product(r[1]).each.collect{|x,y| [x,y] if x!=y}.compact
n2 = n1.product(r[2]).each.collect{|x,y| x+=[y] if !x.include?y}.compact
n3 = n2.product(r[3]).each.collect{|x,y| x+=[y] if !x.include?y}.compact
n4 = n3.product(r[4]).each.collect{|x,y| x+=[y] if !x.include?y}.compact
n5 = n4.product(r[5]).each.collect{|x,y| x+=[y] if !x.include?y}.compact
n6 = n5.product(r[6]).each.collect{|x,y| x+=[y] if !x.include?y}.compact
n7 = n6.product(r[7]).each.collect{|x,y| x+=[y] if !x.include?y}.compact

puts n7.each.collect{|v| v.join if (v.join =~ er[0] && v.join =~ er[1] && 
  v.join =~ er[2] && v.join =~ er[3] && v.join =~ er[4] && v.join =~ er[5] && 
  v.join =~ er[6] && v.join =~ er[7])}.compact