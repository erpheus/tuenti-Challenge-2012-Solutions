# Challenge 4: 20 fast 20 furious
# Author: José Antonio Porras

class Numeros
  attr_accessor :recorrido

  def initialize(tope,group)
    @vector = group
    @tope = tope
    @recorrido = []
    @residuo = []
    @i = 0
  end

  def recorrido
    @recorrido
  end

  def get_prefix(subgroup)
    i=0
    subgroup += @vector if subgroup.inject(:+)<=@tope
    while(subgroup[0..i].inject(:+)<=@tope) do
      i+=1
    end
    @i = i
    return subgroup[0..i-1],subgroup[i..subgroup.length]
  end

  def iterate
    ciclo = false
    i=@i
    while !ciclo  do
      i += @i
      if @vector.inject(:+)<=@tope
        @recorrido << @vector
        @recorrido << 0
        ciclo = true
      else
        if @i==0 then
          h,@residuo = get_prefix(@vector)
        else
          h,@residuo = get_prefix(@residuo)
          if @recorrido.include?(h) && i>=@vector.length
            ciclo = true
            @recorrido << @recorrido.index(h)
          else  
            if @recorrido.length>@vector.length
              #ciclo = true
            end  
          end
        end
        @recorrido << h if !ciclo
      end
    end
  end

  # devuelve tanto el recorrido fijo como el ciclico
  def recorridos
    rf = []
    rc = []
    if @recorrido.last.class.eql?("Array")
      rf = @recorrido
    else
      if @recorrido.last == 0 then
        rc = @recorrido[@recorrido.last..@recorrido.length-2]
        rf = rc
      else
        rf = @recorrido[0..@recorrido.last-1]
        rc = @recorrido[@recorrido.last..@recorrido.length-2]
      end
    end
    @rf = rf
    @rc = rc
    return rf,rc
  end

  def coste_estatico(n)
    value = 0
    costef = @rf.collect{|e| e.inject(:+)}
    if (n<=costef.length) && (n>=0) then
      value = costef[0..n-1].inject(:+)
    else
      value += costef.inject(:+) if costef.length>0
      value += coste_ciclo(n-costef.length)     
    end
    return value
  end
    
# optimización. operaciones aritméticas  
  def coste_ciclo(n)
    value = 0
    costec = @rc.collect{|e| e.inject(:+)}
    complete = n/costec.length
    semicomplete = n%costec.length
    value = complete * costec.inject(:+)
    i=0
    while i<semicomplete do
      value += costec[i]
      i+=1
    end
    return value
  end
end

@values = 0
line1 = []
line2 = []

ARGF.each_with_index{|data,index|
  if index == 0
    @values = data.to_i  
  else
    line1 << data if index%2 == 1
    line2 << data if index%2 == 0
  end
}
i = 0

while (i<@values) do
  opts = line1[i].strip.split(" ").collect{|v| v.to_i}
  group = line2[i].strip.split(" ").collect{|v| v.to_i}
  n = Numeros.new(opts[1],group)
  n.iterate
  n.recorridos
  puts n.coste_estatico(opts[0])
  i+=1
end


