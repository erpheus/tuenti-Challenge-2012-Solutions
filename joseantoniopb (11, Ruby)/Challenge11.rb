# Challenge 11: Descrambler
# Author: José Antonio Porras

@points = Hash[*%w(A 1 E 1 I 1 L 1 N 1 O 1 R 1 S 1 T 1 U 1 D 2 G 2 B 3 C 3 M 3 P 3 F 4 H 4 V 4 W 4 Y 4 K 5 J 8 X 8 Q 10 Z 10)]

p = []
f = File.open("#{File.dirname(__FILE__)}/descrambler_wordlist.txt","r")
@words = f.sysread(f.size)

def palabra_valida?(rack,palabra)
  valida = true
  if palabra.length>rack.length
    return !valida
  else
    i=0
    while i<palabra.length && valida
      valida = (palabra.count(palabra[i])<=rack.count(palabra[i])) ? true : false
      i+=1
    end
    return valida
  end
end

def valor_palabra(palabra)
  return palabra.each_char.collect{|c| @points[c].to_i}.inject(:+)
end


def buscar_palabra(rack)
  r = Regexp.new("\\b[#{rack}]{1,#{rack.length}}\\b")
  a = []
  tmp = @words.scan(r).each.collect{|r| [valor_palabra(r),r] if palabra_valida?(rack,r)}.compact.dup
  return nil if tmp.empty?
  max_val = tmp.sort{|a,b| b<=>a}.first[0]
  aux = []
  while !tmp.assoc(max_val).nil?
    aux << tmp.assoc(max_val)
    tmp.delete(tmp.assoc(max_val))
  end  
  return [max_val,aux.each.map{|x,y| y}.sort.first]
end

def juego(rack,palabra)
  puntuaciones=[]
  palabra.each_char{|c|
    puntuaciones << buscar_palabra(rack+c)
  }
  tmp =  puntuaciones.compact.dup
  
  max_val = tmp.sort{|a,b| b<=>a}.first[0] 
  aux=[]
  while !tmp.assoc(max_val).nil?
    aux<<tmp.assoc(max_val)
    tmp.delete(tmp.assoc(max_val))
  end
  return [max_val,aux.each.map{|x,y| y}.sort.first]
end

ARGF.each_with_index{|l,i|
  if i>0
    puntos,palabra = juego(l.strip.split(" ")[0],l.strip.split(" ")[1])
    puts "#{palabra} #{puntos}"
  end
}