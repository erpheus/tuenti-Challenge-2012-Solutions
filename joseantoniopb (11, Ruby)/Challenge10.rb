# Challenge 10: Coding m00re and m00re
# Author: José Antonio Porras
# Required Library rpn -> gem install rpn

require "pp"
require "rpn"                 # gem install rpn (reverse polish notation)

# 4 mirror .	                *(-1)
# 3 breadandfish # .	        Duplica izquierdo
# 5 3 fire .                  Parece maximo
# 3 1 $ .                     RESTA
# 3 1 dance $ .               RESTA INVERSA
# 4 2 conquer .               MODULO
# 4 2 & .                     DIVISION
# 1 1 @ .                     SUMA
# 2 3 @ 1 $ .                 SUMA Y RESTA


def parse(string)
  s = string.split(" ")
  i=0
  while i<s.length
    s[i] = "+" if s[i].eql?("@")
    s[i] = "-" if s[i].eql?("$")
    s[i] = "*" if s[i].eql?("#")
    s[i] = "/" if s[i].eql?("&")
    s[i] = "%" if s[i].eql?("conquer")
    s[i-1],s[i-2],s[i] = s[i-2],s[i-1],"" if s[i].eql?("dance")
    s[i] = "-1 *" if s[i].eql?("mirror")
    s[i] = s[i-1] if s[i].eql?("breadandfish")
    s[i] = "" if s[i].eql?(".")
    if s[i].eql?("fire") then
      s[i-2] = (s[i-1].to_i>s[i-2].to_i) ? s[i-1] : s[i-2]
      s.delete_at(i-1)
      s.delete_at(i)
      i-=2
    end
    i+=1
  end
  return s.join(" ")
end  

STDIN.each_line{|l|
  v = parse(l.strip)
  my_rpn = RPN::Calculator.new
  puts my_rpn.solve v
}