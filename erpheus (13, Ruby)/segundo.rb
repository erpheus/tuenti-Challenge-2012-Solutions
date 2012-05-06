def numberOfOnes(x)
  b = 0
  while x > 0
    x &= x - 1
    b += 1
  end
  return b
end


BASE2_ARRAY=[1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216,33554432,67108864,134217728,268435456,536870912,1073741824,2147483648,4294967296,8589934592,17179869184,34359738368,68719476736,137438953472,274877906944,549755813888,1099511627776,2199023255552,4398046511104,8796093022208,17592186044416,35184372088832,70368744177664,140737488355328,281474976710656,562949953421312,1125899906842624,2251799813685248,4503599627370496,9007199254740992,18014398509481984,36028797018963968,72057594037927936,144115188075855872,288230376151711744,576460752303423488,1152921504606846976,2305843009213693952,4611686018427387904,9223372036854775808]

=begin
def solve(total)

	if(total==0 or total==1)
		return total
	end

	parCola = Struct.new(:inicio,:fin)

	upStart = total
	downStart = total/2

	maxNumberUp = (Math.log(upStart)/Math.log(2)).floor
	maxNumberDown = (Math.log(downStart)/Math.log(2)).floor

	if numberOfOnes(upStart+1)==1
		maxNumberUp+=1
	end

	if numberOfOnes(downStart+1)==1
		maxNumberDown+=1
	end

	maxUp = BASE2_ARRAY[maxNumberUp]
	maxDown = BASE2_ARRAY[maxNumberDown]

	maximo = maxNumberUp + numberOfOnes(total-(maxUp-1))

	cola = Array.new
	colaNuevos = Array.new

	numberActual = maxNumberUp-1

	par=parCola.new(maxUp-2,downStart-1)
	cola.push(par)

	while numberActual + maxNumberDown > maximo

		if cola.empty?
			return maximo
		end

		par=cola.pop
		actual=par[:inicio]
		fin=par[:fin]
		diff = 0

		while actual >= fin

			temp = numberActual + numberOfOnes(total-actual)

			if temp > maximo
				maximo = temp
			end

			nuevo = actual - BASE2_ARRAY[diff]

			if diff > 0
				par = parCola.new(actual-1,nuevo+1)
				colaNuevos.push(par)
			end

			diff += 1

			actual = nuevo

		end

		if cola.empty?

			cola=colaNuevos
			numberActual-=1
			colaNuevos=Array.new

		end


	end

	return maximo

end


def bruteSolve(x)
	max=0

	x.times do |i|
		j = x - i
		temp=numberOfOnes(i)+numberOfOnes(j)
		if temp>max
			max=temp
		end
	end

	return max
end

=begin

puts solve(1)
puts solve(6)
puts solve(2135)


20.times do 
	x=rand(10**6)
	time1=Time.new
	uno=solve(x)
	time2=Time.new
  dos=uno
	#dos=bruteSolve(x)
	time3=Time.new
	if uno!=dos
		puts "fallo con "+x.to_s
		puts "resultado malo: "+uno.to_s
		puts "resultado bueno: "+dos.to_s
	end
	puts ""
	puts "resultado:"
	puts "numero: "+x.to_s
	puts "tiempo guay: "+(time2-time1).to_s
	puts "tiempo bruto: "+(time3-time2).to_s
	puts ""
	puts ""

end

=end

#En un principio pense que no podia ser tan facil :S Sobretodo despues del primero
def newSolve(total)
	maxNumberUp = Math.log2(total).floor

	if numberOfOnes(total+1)==1
		maxNumberUp+=1
	end

	maxUp = 2**maxNumberUp


	maximo = maxNumberUp + numberOfOnes(total-(maxUp-1))
	return maximo
end

number=gets.chomp.to_i

number.times do |n|
	line = gets.chomp
	puts "Case \##{n+1}: " + newSolve(line.to_i).to_s

end


