def solve()

  line=gets.chomp
  min=line.to_i
  max=line.to_i
  minTime=0
  maxTime=0
  time=0
  temp=min
  tempTime=minTime

  while line=gets
    line=line.chomp
    time += 100
    n=line.to_i
    if n > max
      max = n
      maxTime = time
    end

    if (max - min) < (n - temp)
      max = n
      maxTime = time
      min = temp
      minTime = tempTime
    end

    if n < temp
      temp = n
      tempTime = time
    end

  end

  puts minTime.to_s + " " + maxTime.to_s + " " + (max-min).to_s

end

solve


    
    
  