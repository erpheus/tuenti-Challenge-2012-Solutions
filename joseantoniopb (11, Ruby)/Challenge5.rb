#!/usr/bin/env ruby
# Challenge 5: Time is never time again
# Coded by José Antonio Porras
#encoding: UTF-8

#  ---0---
# |1    2| 
#  ---3---
# |4    5|
#  ---6---

class Clocks
  attr_accessor :f1,:f2,:hash,:fichero

  LEDS = {0=>[1,1,1,0,1,1,1],
    1=>[0,0,1,0,0,1,0],
    2=>[1,0,1,1,1,0,1],
    3=>[1,0,1,1,0,1,1],
    4=>[0,1,1,1,0,1,0],
    5=>[1,1,0,1,0,1,1],
    6=>[1,1,0,1,1,1,1],
    7=>[1,0,1,0,0,1,0],
    8=>[1,1,1,1,1,1,1],
    9=>[1,1,1,1,0,1,1]
  }

  def initialize
    unless File.exists?("#{File.dirname(__FILE__)}/calculos.txt")
      @fichero = File.open("#{File.dirname(__FILE__)}/calculos.txt","w+")
      self.generate_hash
      @fichero.close
    end
      f = File.open("#{File.dirname(__FILE__)}/calculos.txt","r")
      @times = []
      @values = []
      f.each_line{|l|
        @times << l.split("<->")[1].strip.to_i
        @values << l.split("<->")[2].strip.to_i
      }
    end

    def set(string)
      @f1,@f2 = parse_date(string)
    end  

    def hamming(d1,d2)
      d = []
      z = LEDS[d2]
      LEDS[d1].each_with_index{|a,i|
        if a==0 then
          d[i] = z[i]==1 ? 1 : 0   
        else
          d[i] = z[i]==1 ? 0 : 0
        end
      }
      return d
    end

    # Calculo de transicion mínima entre dos fechas dadas
    def calculo(f1,f2)
      v = 0
      st1 = "%02d" % f1.hour + "" + "%02d" % f1.min + "" + "%02d" % f1.sec
      st2 = "%02d" % f2.hour + "" + "%02d" % f2.min + "" + "%02d" % f2.sec
      i = 0
      while i<st2.length do
        v += hamming(st1[i].to_i,st2[i].to_i).inject(:+)
        i+=1
      end
      cad = "#{st1}<->#{st2}<->#{v}\n"
      @fichero.write(cad) unless @fichero.nil?  
      return v  
    end

    # generacion de hash para 1 dia
    def generate_hash    
      value = 36
      hash = []
      t1 = Time.new(2000,1,1,0,0,0)
      t2 = Time.new(2000,1,2,0,0,0)
      while t1<t2
        c = calculo(t1,t1+1)
        t1+=1
      end  
    end

    ################ SOLUCION RECOGIDA DE LA ANTERIOR TUENTI CHALLENGE 
    ################ AUTOR: MANUEL FLORES -> https://github.com/manufloresv/tuenticontest/blob/master/challenge06.rb 

    def segments(s)
      seg=[6,2,5,5,4,5,6,3,7,6] # segments of each digit
      sum=seg.each_index.map {|i| seg[0..i].inject(0, :+)} # sum of segments from 0 to i
      sum+=[0]

      # calc basic units
      # hh:mm:ss
      ss = s%60
      mm = s/60%60
      hh = s/(60*60)%24
      # h2,h1:m2,m1:s2,s1
      s2,s1 = ss/10, ss%10
      m2,m1 = mm/10, mm%10
      h2,h1 = hh/10, hh%10

      # calc how many times each display turns on after s seconds
      # I should explain this mathematical formula
      b0 = sum[9]     *(s/10)    + sum[s1]
      b1 = sum[5]*10  *(s/60)    + sum[s2-1]*10    + seg[s2]*(              s1+1)
      b2 = sum[9]*60  *(s/600)   + sum[m1-1]*60    + seg[m1]*(              ss+1)
      b3 = sum[5]*600 *(s/3600)  + sum[m2-1]*600   + seg[m2]*(        m1*60+ss+1)
      b4 = sum[9]*3600*(s/36000) + sum[h1-1]*3600  + seg[h1]*(        mm*60+ss+1)
      b5 =                         sum[h2-1]*36000 + seg[h2]*(h1*3600+mm*60+ss+1)

      # return the sum of blinks of each display
      return b0+b1+b2+b3+b4+b5
    end

    # support for full days, when the clock position is reset
    def total_segments(s)
      day=86400
      if (s<day)
        return segments(s)
      else
        return segments(s%day) + segments(day-1)*(s/day)
      end
    end  

    ################################################################  
    def old_calc
      return total_segments((@f2-@f1).to_i)
    end

    def new_calc  
      s = (@f2-@f1).to_i
      dias_completos = (s/86400)
      st2 = "%02d" % @f2.hour + "" + "%02d" % @f2.min + "" + "%02d" % @f2.sec
      idx = @times.index(st2.to_i)
      diferencia_horaria = (@values[0..idx]).inject(:+)
      return dias_completos*146443 + diferencia_horaria+36
    end

    private
    def parse_date(string)
      m = string.scan(/(\d{4})-(\d{2})-(\d{2}).(\d{2}):(\d{2}):(\d{2})/)
      d1 = m[0].collect{|a| a.to_i}
      d2 = m[1].collect{|a| a.to_i}

      [Time.new(d1[0],d1[1],d1[2],d1[3],d1[4],d1[5]),
      Time.new(d2[0],d2[1],d2[2],d2[3],d2[4],d2[5])]
    end
  end

  c = Clocks.new

  ARGF.each_line do |line|
    c.set(line.strip)
    b = c.old_calc
    a = c.new_calc
    puts b-a
  end
