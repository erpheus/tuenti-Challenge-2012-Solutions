class PuntoDeCruz

	def calcularMaximaFuente(alto,ancho,mensaje)

		@hash=Hash.new

		numLineas = 1
		palabras = mensaje.split(" ")
		numPalabras = palabras.length
		longitudes = []
		palabras.each do |palabra|
			longitudes << palabra.length
		end
		maximo = 0

		numCaracteres = longitudes.inject(:+)
		palabraMasLarga = longitudes.max
		fuenteMax = alto * ancho / numCaracteres.to_f
		numLineas = (alto/fuenteMax).ceil.to_i
		numColumnasMin = ancho/fuenteMax

		while(numPalabras >= numLineas)

			temp = alto/numLineas
			minlong = minLongitudMensaje(longitudes,numLineas)

			if (cabeMensaje(alto,ancho,minlong,temp,numLineas))
				if temp > maximo
					return temp
				else
					return maximo
				end
			else
				if minlong == 0
					temp = 0
				else
					temp = ancho/minlong
				end

				if temp > maximo
					maximo = temp
				end
				
			end

			numLineas += 1

		end

		return maximo

	end

	def minLongitudMensaje(tams, numLineas)

		if numLineas == 1
			cantidad = tams.length
			resultado = cantidad-1 + tams.inject(:+)
			@hash[ cantidad.to_s + ";" + numLineas.to_s ] = resultado
			return resultado
		end

		minimo = -1
		cantidad = tams.length

		if numLineas >= cantidad
			resultado = tams.max
			@hash[ cantidad.to_s + ";" + numLineas.to_s ] = resultado
			return resultado
		end

		longitudTotal = tams.length-1 + tams.inject(:+)
		borde = longitudTotal.to_f/numLineas

		total=0
		escogidos=[]
		tams.each_with_index do |tam,index|

			if total+tam > borde
				escogidos << [index,total+tam]
				if index-1 >= 0
					escogidos << [index-1,total-1]
				end
				#if index+1 < cantidad
				#	escogidos << [index+1,total+tam+1+tams[index+1]]
				#end
			end
			total += tam +1

		end

		escogidos.each do |escogido|

			l1 = escogido[1]
			i = escogido[0]+1

			nuevo = tams[i..-1]

			if nuevo == nil or nuevo.empty?
				l2 = l1
			else
				if l1 < longitudTotal - l1 - (numLineas-2)
					if @hash.key?(cantidad.to_s + ";" + numLineas.to_s)
						l2 = @hash[cantidad.to_s + ";" + numLineas.to_s]
					else
						l2 = minLongitudMensaje(nuevo,numLineas-1)
					end
				else
					l2=l1
				end
			end

			if l1 > l2
				if l1 < minimo or minimo == -1
					minimo = l1
				end
			else
				if l2 < minimo or minimo == -1
					minimo = l2
				end
			end
		end

		if minimo == -1
			resultado = 0
		else
			resultado = minimo
		end

		@hash[ cantidad.to_s + ";" + numLineas.to_s ] = resultado
		return resultado
	end


	def cabeMensaje(alto,ancho,minlong,fuente,numLineas)
		if fuente == 0
			return false
		end

		longitud=minlong*fuente
		if longitud <= ancho
			if numLineas*fuente <= alto
				return true
			end
		end
		return false
	end
end

bordado = PuntoDeCruz.new

cantidad=gets.to_i
cantidad.times do |n|
	datos = gets.chomp.split(" ")
	w=datos[0].to_i
	h=datos[1].to_i
	ct=datos[2].to_i
	mensaje=gets.chomp

	ancho = w * ct
	alto = h * ct

	fuente = bordado.calcularMaximaFuente(alto, ancho, mensaje)

	if fuente == 0
		hilo = 0
	else
		caracteres = mensaje.split(" ").join("").length
		hilo = (((fuente**2)/2.0)/ct )* caracteres
	end
	puts "Case \##{n+1}: "+hilo.ceil.to_i.to_s
end








































=begin


def minLongitudMensaje(mensaje, numLineas)

	longitud = mensaje.length

	if numLineas == 1
		return longitud
	end

	longitudes = Array.new
	
	palabras = mensaje.split(" ")

	if numLineas == palabras.length
		maximo=0
		palabras.each do |palabra|
			l=palabra.length
			if l>maximo
				maximo = l
			end
		end
		return maximo
	end

	total=0
	palabras.each do |palabra|

		l1 = total + palabra.length

		nuevo = mensaje[l1..-1]

		if nuevo == nil
			l2 = l1
		else
			l2 = minLongitudMensaje(nuevo.strip,numLineas-1)
		end

		if l1 > l2
			longitudes << l1
		else
			longitudes << l2
		end
		total = l1 + 1
	end

	if longitudes.empty?
		return 0
	end

	return longitudes.min

end


def minLongitudMensaje(mensaje, numLineas)

	longitud = mensaje.length

	if numLineas == 1
		return longitud
	end

	borde = (longitud.to_f/numLineas).ceil

	anteriorlength = 0

	longitud1=0
	longitud2=0
	
	l1=0

	palabras = mensaje.split(" ")
	total=0

	palabras.each do |palabra|

		anteriorlength = l1

		l1 = total + palabra.length

		if l1 >= borde

			nuevo = mensaje[l1..-1]

			if nuevo == nil
				l2 = l1
			else
				l2 = minLongitudMensaje(nuevo.strip,numLineas-1)
			end

			if l1 > l2
				longitud1 = l1
			else
				longitud1 = l2
			end

			break

		end
		
		total = l1 + 1

	end

	if anteriorlength!=0

		nuevo = mensaje[l1..-1]

		if nuevo == nil
			l2 = l1
		else
			l2 = minLongitudMensaje(nuevo.strip,numLineas-1)
		end

		if l1 > l2
			longitud2 = l1
		else
			longitud2 = l2
		end

	end

	if longitud1<longitud2
		return longitud1
	else
		return longitud2
	end

end

def minLongitudMensaje(tams, numLineas)

	if numLineas == 1
		return tams.length-1 + tams.inject(:+)
	end

	minimo = -1

	if numLineas >= tams.length
		return tams.max
	end

	total=0
	i=1
	tams.each do |tam|

		l1 = total + tam
		nuevo = tams[i..-1]

		if nuevo == nil or nuevo.empty?
			l2 = l1
		else
			l2 = minLongitudMensaje(nuevo,numLineas-1)
		end

		if l1 > l2
			if l1 < minimo or minimo == -1
				minimo = l1
			end
		else
			if l2 < minimo or minimo == -1
				minimo = l2
			end
		end
		i += 1
		total = l1 + 1
	end

	if minimo == -1
		return 0
	else
		return minimo
	end
end

=end