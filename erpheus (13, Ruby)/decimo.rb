class StrangeLanguage
  
  #0,3 and 4 aren't actual numbers of arguments, but this was an easy implementation for each functions particularities
  NUM_ARGUMENTS = Hash["."=>0,"mirror"=>1,"breadandfish"=>4,"#"=>2,"fire"=>2,"$"=>2,"dance"=>3,"conquer"=>2,"&"=>2,"@"=>2]
  METHOD_CALL = Hash["mirror"=>:inverse,"breadandfish"=>:absolute_value,"#"=>:*,"fire"=>:max,"$"=>:-,"dance"=>:swap,"conquer"=>:%,"&"=>:/,"@"=>:+]
  
  def interpretar(expresion)
    
    pila=Array.new
    
    tokens = expresion.split(" ")
    
    tokens.each do |token|
      if token.is_number?
        pila << token.to_i
      else
        case NUM_ARGUMENTS[token]
        when 1
          operand = pila.pop
          pila << operand.send(METHOD_CALL[token])
        when 2
          operand2 = pila.pop
          operand1 = pila.pop
          pila << operand1.send( METHOD_CALL[token], operand2 )
        when 3
          operand2 = pila.pop
          operand1 = pila.pop
          pila << operand2
          pila << operand1
        when 4
          operand = pila.last
          pila << operand
        end
        
      end
      
    end
    
    #if pila.length != 1
    #  raise "Malformed expression"
    #end
    return pila.first
    
  end
end

class String
  def is_number?
    if self.to_i.to_s == self
      return true
    end
    return false
  end

end

class Numeric
  def inverse
    return -self
  end
  def absolute_value
    if self < 0
      return -self
    else
      return self
    end
  end
  def squared
    return self**2
  end
  def max(other)
    if self>other
      return self
    else
      return other
    end
  end
end

strange = StrangeLanguage.new

while line=gets
  line=line.chomp
  puts strange.interpretar(line)
end
  