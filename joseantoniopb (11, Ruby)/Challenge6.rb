# Challenge 6: Cross-stitched fonts
# Author José Antonio Porras

class PuntoCruz
  def initialize(w,h,ct,str)
    @w = w
    @h = h
    @ct = ct
    @str = str
    @ch = caracteres_permitidos
    @lineas = 0
  end
  
  def cabe?(str,x,y,fontsize,lineas)
    if str.eql? ""
      @lineas = lineas
      return true
    else
      d = str.strip.split(" ")
      head = []
      i=0
      head << d[i]
      # completamos primera linea hasta que esté completa
      while(head.join(" ").length*fontsize<=x)&&(i<d.length)
        i+=1
        head << d[i]
      end
      if i==0
        return false
      end
      return cabe?(d[i..(d.length-1)].join(" ").strip,x,y-fontsize,fontsize,lineas+1) && (y>0)
    end
  end
  
  def caracteres_permitidos
    caracteres = []
    caracteres += (0..9).to_a
    caracteres += ('a'..'z').to_a
    caracteres += ('A'..'Z').to_a
    caracteres += %w(! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ ]   ^ _ ` { | } ~ )
    return caracteres
  end

  def mensaje_acortado
    cad = ""
    @str.each_char{|b|
      if @ch.include? b
        cad += b
      end
    }
    return cad
  end

  def get_fontsize
    fontsize = @h*@ct
    while (cabe?(@str,@ct*@w,@ct*@h,fontsize,0)==false) && (fontsize>0)
      fontsize-=1
    end

    #A partir de aqui, todos los fontsize inferiores cabrán
    #Debemos saber cual tiene mejor beneficio
    while (fontsize*@lineas > @h*@ct)
      fontsize -= 1
      cabe?(@str,@ct*@w,@ct*@h,fontsize,0)   
    end    
    return fontsize
  end

  def calcular
    fontsize = get_fontsize.to_f
    puntada = 1.0/@ct
    ppc = (fontsize**2.0)/2.0
    media_hilo = ppc.to_f*puntada.to_f
    ch = mensaje_acortado.length
    return ch*media_hilo  
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

i=0
while i<@values do
  l1 = line1[i].strip.split(" ")
  l2 = line2[i].strip
  pc = PuntoCruz.new(l1[0].to_i,l1[1].to_i,l1[2].to_i,l2)
  puts "Case ##{i+1}: #{pc.calcular.round}"  
  i+=1
end