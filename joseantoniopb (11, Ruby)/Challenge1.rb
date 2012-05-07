# Challenge1: The cell phone keypad
# Author: José Antonio Porras

#encoding: UTF-8

## Redefinition of upcase? and downcase?
class String
  def upcase?
    self.eql?(self.upcase)
  end

  def downcase?
    self.eql?(self.downcase)
  end
end


# key => [pos,ipos]
@keys = {
  " "=>[1,1],"1"=>[1,2],
  "a"=>[2,1],"b"=>[2,2],"c"=>[2,3],"2"=>[2,4],
  "d"=>[3,1],"e"=>[3,2],"f"=>[3,3],"3"=>[3,4],
  "g"=>[4,1],"h"=>[4,2],"i"=>[4,3],"4"=>[4,4],
  "j"=>[5,1],"k"=>[5,2],"l"=>[5,3],"5"=>[5,4],
  "m"=>[6,1],"n"=>[6,2],"o"=>[6,3],"6"=>[6,4],
  "p"=>[7,1],"q"=>[7,2],"r"=>[7,3],"s"=>[7,4],"7"=>[7,5],
  "t"=>[8,1],"u"=>[8,2],"v"=>[8,3],"8"=>[8,4],
  "w"=>[9,1],"x"=>[9,2],"y"=>[9,3],"z"=>[9,4],"9"=>[9,5],
  "0"=>[11,1],
  "^"=>[12,1]
}

# pos => [row,column]
@pos = {
  1 => [1,1], 2 => [1,2],  3 => [1,3],
  4 => [2,1], 5 => [2,2],  6 => [2,3],
  7 => [3,1], 8 => [3,2],  9 => [3,3],
  10 => [4,1],11 => [4,2], 12 => [4,3]
}

# el bloqueo de mayuscula será representado por ^
# ejemplo: Mi perro se llama BOBBY
# salida: ^m^i perro se llama ^bobby
def transform_string(string)
  lockcaps = false
  out = ""
  string.each_char{|c|
    if c.upcase? && !lockcaps
      if c=~/[A-z]/
        out += "^#{c.downcase}"
        lockcaps = true
      else 
        out += c
      end
    elsif c.downcase? && lockcaps
      if c=~/[A-z]/
        out += "^#{c}"
        lockcaps = false
      else
        out += c
      end
    else
      out += c.downcase
    end

  }
  return out
end


def distance(from,to)
  d = 0
  h = 0
  v = 0
  rx = @keys[from][0]
  ry = @keys[to][0]

  xf,yf = @pos[rx]
  xt,yt = @pos[ry]

  dx = (xf-xt).abs
  dy = (yf-yt).abs

  # number of diagonals
  d = (dx == dy) ? dx : [dx,dy].min
  px = (xt >= xf+d) ? xf+d : xf-d
  py = (yt >= yf+d) ? yf+d : yf-d
  # number of verticals and horizontals movements
  v = (px - xt).abs
  h = (py - yt).abs
  [d,h,v]
end

def calculate(string)
  value = 0
  i = j = 0
  while (i<string.length-1) do
    c1 = string[i]
    c2 = string[i+1]
    d = distance(c1,c2)
    value += d[0]*350 + d[1]*200 + d[2]*300 # movement
    value += (@keys[c2][1])*100
    value += (@keys[c1][0]==@keys[c2][0]) ? 500 : 0
    i += 1
  end
  return value
end

#MAIN PROGRAM

ARGF.each_with_index{|line,idx|
  puts calculate(transform_string("0#{line.strip}")) unless idx==0
}
