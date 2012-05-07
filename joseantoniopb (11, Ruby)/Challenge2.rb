#Challenge2: The binary granny
#Author: José Antonio Porras
#encoding: UTF-8

#Calculamos el numero con el mayor número de unos inmediatamente inferior al número dado
#Restamos el número dado con este último y obtenemos el supuesto x
def binary_granny(number)
  x = (Math.log(number)/Math.log(2)).floor
  y = []
  x.times{y<<1}
  (number-y.join.to_i(2)).to_s(2).count("1")+x
end

# MAIN PROGRAM
ARGF.each_with_index{|l,idx|
  unless idx==0
    puts "Case ##{idx}: #{binary_granny(l.strip.to_i)}"
  end
}