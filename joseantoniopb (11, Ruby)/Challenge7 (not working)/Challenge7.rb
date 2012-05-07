#!/usr/bin/env ruby
require "pp"
# Challenge 7: The "secure" password
# Coded by José Antonio Porras

input = []
STDIN.each{|line|
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


# Me aseguro saber cual es el primer y último carácter de la contraseña
def generar_indice_probabilidad(input)
  chars = []
  nivel = []
  input.each{|e| e.each_char{|c| chars << [c,e.index(c)] }}
  chars.sort.each{|c| nivel << [m_assoc(chars.sort,c[0]).inject{|sum,v| (v+sum)/2.0},c[0]]}
  return nivel.uniq.sort
end 

@ip = generar_indice_probabilidad(input)
@caminos =[]

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

def camino(vector,table)
  v = []
  vector.each{|x|
    #v << [x[0]] + vector.assoc(x[1]) unless vector.assoc(x[1]).nil?
    c_vector = vector.dup
    while !c_vector.assoc(x.last).nil?  
      v << x[0..x.length-2] + c_vector.assoc(x.last) 
      c_vector.delete(c_vector.assoc(x.last))
    end
  }
  return v
end


def dependientes(vector,num)
  a = []
  v = vector.dup
  while !v.assoc(num).nil?
    r = v.assoc(num)
    a << r[1]
    v.delete(r)
  end
  return a
end

def mismos_dependientes(vector,num)
  n=nil
  d1 = dependientes(vector,num)
  vector.each{|e|
    unless e[0].eql?(num) then
      d2 = dependientes(vector,e[0])
      if d2 == d1
        n = e[0]
      end
    end
  }
  return n
end  

def dependientes_inverso(vector,num)
  a = []
  v = vector.dup
  while !v.rassoc(num).nil?
    r = v.rassoc(num)
    a << r[0]
    v.delete(r)
  end
  return a
end


def recursivo(vector,i,camino)
  if dependientes(vector,i).length == 0
    #pp @caminos
    @caminos << camino+i if camino.length<8
    return camino+=i
  else

      dependientes(vector,i).each{|a|
        if camino.length<8
          camino += i unless camino.include?(i)
          ma = mismos_dependientes(vector,i)
          if !ma.nil? && !camino.include?(ma)
            camino += ma
          end      
          @caminos << camino if camino.length<8
          recursivo(vector,a,camino)
        end
      }
    return camino  
  end
end


def recursivo_inverso(vector,i,camino)
  if dependientes_inverso(vector,i).length == 0
    return camino+=i
  else
    dependientes_inverso(vector,i).each{|a|
      camino += i unless camino.include?(i)
      @caminos << camino
      recursivo_inverso(vector,a,camino)
    }
    return camino  
  end
end


orden=[]
r = table[0].each.map{|e| e.uniq}
8.times{|c|
  orden << ordena_array(r[c],input)
}

ady = orden.flatten(1).uniq.sort
recursivo(ady,"#{@ip.assoc(0)[1]}","")
puts @caminos.sort{|a,b| b.length<=>a.length}.collect{|v| v if v.length==8}.compact


