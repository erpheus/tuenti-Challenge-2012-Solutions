
# Challenge 7: The "secure" password
# Coded by José Antonio Porras

require "rgl/adjacency"
require "rgl/dot"
require "rgl/bidirectional"
require "rgl/implicit"
require "rgl/traversal"
require "rgl/topsort"
require "rgl/connected_components"
require "gratr"
require "gratr/dot"
require "pp"

include GRATR

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

input = %w(
2Ad
12c
2Ac
1Bc
1cd
1xZ
1dx
BdZ
)

#input = [] 
STDIN.each_line{|l|
 #    input << l.strip
}

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


# Me aseguro saber cual es el primer y último carácter de la contraseña
def generar_indice_probabilidad(input)
  chars = []
  nivel = []
  input.each{|e| e.each_char{|c| chars << [c,e.index(c)] }}
  chars.sort.each{|c| nivel << [m_assoc(chars.sort,c[0]).inject{|sum,v| (v+sum)/2.0},c[0]]}

  return nivel.sort
end

def generar_matrix_adyacencia(input)
  table = Array.new(input.length)
  input.each_with_index{|d,index|
    table[index] = Array.new(8)
    8.times{|position| table[index][position] = [] }
    8.times{|position|
      (0..5).each{|i| table[0][position+i] << d[0] if position+i <6}
      (1..6).each{|i| table[0][position+i] << d[1] if position+i <7}
      (2..7).each{|i| table[0][position+i] << d[2] if position+i <8}
    }
  }

  orden=[]
  r = table[0].each.map{|e| e.uniq}
  8.times{|c|
    orden << ordena_array(r[c],input)
  }
  return orden.flatten(1).sort
end


@ip = generar_indice_probabilidad(input)
@ady = generar_matrix_adyacencia(input)




dg=RGL::DirectedAdjacencyGraph.new

@ady.each{|x,y|
  dg.add_edge(x,y)
}

 dg.strongly_connected_components
 
 dfsi = dg.dfs_iterator
 100.times{
   
 }
 

 
 
 

camino=""
 dg.depth_first_search{|d| camino += d
  
  }

caminos = []    
c = camino.reverse
caminos << c
#puts caminos.sort



