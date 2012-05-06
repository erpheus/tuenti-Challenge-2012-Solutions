class String

	def addHaming

		bits  = self.length
		exponente=0
		potencia=1
		indice=2
		result=" "*(2*bits)

		exponente = 2
		potencia = 4

		self.each_char do |char|
			if indice+1 == potencia
				indice += 1
				result[indice]=char
				exponente += 1
				potencia = 2**exponente
			else
				result[indice]=char
			end
			indice += 1
		end

		exponente=0
		potencia=1

		parities=Array.new
		while potencia < indice
			parities[exponente]=false
			exponente+=1
			potencia = 2**exponente
		end

		bits += parities.length

		#puts ""
		#puts result
		#puts ""

		parities.each_with_index do |par,index|

			potencia = 2**index

			indice=potencia

			(potencia-1).times do
				if indice < bits and result[indice] == 49
					#puts "Exponente #{index}, indice: #{indice}"
					par = !par
				end
				indice += 1
			end
			indice += potencia

			while indice < bits
				potencia.times do
					if indice < bits and result[indice] == 49
						par = !par
					end
					indice += 1
				end
				indice += potencia
			end

			parities[index]=par

			if par == true
				result[(2**index)-1]=49
			else
				result[(2**index)-1]=48
			end

		end

		return result.strip


	end

	def hammingCorrectConParidad

		paridades = Array.new
		bits = self.length
		paridadTotal = false
		#self.each_char do |char|
		#	if char == 49
	#			paridadTotal = !paridadTotal
	#		end
	#	end
	#	if self[-1] == 49 and paridadTotal == false
	#		comprobacionP = true
	#	elsif self[-1] == 48 and paridadTotal == true
	#		comprobacionP = true
	#	else
	#		comprobacionP = false
	#	end

		exponente = 0


		while (potencia = 2**exponente) < bits

			paridad = false

			indice = potencia-1

			while indice < bits

				potencia.times do
					if indice < bits and self[indice] == 49
						paridad =  !paridad
					end
					indice += 1
				end

				indice += potencia

			end

			paridades[exponente]=paridad
			exponente += 1
		end

		if not paridades.include? true
			#if not comprobacionP
			#	if self[-1] == 49
			#		self[-1] = 48
			#	else
			#		self[-1] = 49
			#	end
			#end
			return self
		end

		#if not comprobacionP
		#	return self
		#end

		numeroDeBit = 0
		paridades.each_with_index do |par,index|
			if par==true
				numeroDeBit += 2**index
			end
		end
		numeroDeBit -= 1
		if numeroDeBit >= bits
			return self
		end

		if self[numeroDeBit] == 49
			self[numeroDeBit] = 48
		else
			self[numeroDeBit] = 49
		end

		return self
	end

	def hammingCorrect

		paridades = Array.new
		bits = self.length
		paridadTotal = false
		#self.each_char do |char|
		#	if char == 49
	#			paridadTotal = !paridadTotal
	#		end
	#	end
	#	if self[-1] == 49 and paridadTotal == false
	#		comprobacionP = true
	#	elsif self[-1] == 48 and paridadTotal == true
	#		comprobacionP = true
	#	else
	#		comprobacionP = false
	#	end

		exponente = 0


		while (potencia = 2**exponente) < bits

			paridad = false

			indice = potencia-1

			while indice < bits

				potencia.times do
					if indice < bits and self[indice] == 49
						paridad =  !paridad
					end
					indice += 1
				end

				indice += potencia

			end

			paridades[exponente]=paridad
			exponente += 1
		end

		if not paridades.include? true
			#if not comprobacionP
			#	if self[-1] == 49
			#		self[-1] = 48
			#	else
			#		self[-1] = 49
			#	end
			#end
			return self
		end

		#if not comprobacionP
		#	return self
		#end

		numeroDeBit = 0
		paridades.each_with_index do |par,index|
			if par==true
				numeroDeBit += 2**index
			end
		end
		numeroDeBit -= 1
		if numeroDeBit >= bits
			return self
		end

		if self[numeroDeBit] == 49
			self[numeroDeBit] = 48
		else
			self[numeroDeBit] = 49
		end

		return self
	end

	def printData

		exponente=0
		indice = 0
		bits = self.length

		resultado = ""

		potencia=2**exponente

		while indice < bits

			if indice+1 == potencia

				exponente+=1
				potencia=2**exponente
				indice+=1

			elsif indice<bits

				resultado += self[indice].chr
				indice += 1
			end
		end

		return resultado

	end
end

while line=gets
	line.chomp!
	#result = line.addHaming
	#if line == result.printData
	#	puts "OK"
	#else
	#	puts "falla: #{result.printData}"
	#end
	#puts line.hammingCorrect.printData
	puts "1001101001101010011111100101000011110010110000111100100011010100010000010111110010110001011010011110001100101011110011110001011101110001110100011101001101000101001000000101111110110011001001111000110011101001110101110010000011000101001110110011101001001101110110001111101101111110100011000011001000110010010011001110001100010101100001001001111110110011101100000101010111111101000001101100111011010100010010111110010"
end







