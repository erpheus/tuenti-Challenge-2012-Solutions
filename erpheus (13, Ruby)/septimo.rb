require 'set'

class PasswordCracker

	def hackear()

		@delante = Array.new
		@detras = Array.new
		@caracteres = Set.new

		(0..9).each do |n|
			@delante[n.to_s[0].ord]=Set.new
			@detras[n.to_s[0].ord]=Set.new
		end

		('a'..'z').each do |c|
			@delante[c[0].ord]=Set.new
			@detras[c[0].ord]=Set.new
		end

		('A'..'Z').each do |c|
			@delante[c[0].ord]=Set.new
			@detras[c[0].ord]=Set.new
		end

		while line = gets

			char1 = line[0].ord
			char2 = line[1].ord
			char3 = line[2].ord

			@caracteres.add char1
			@caracteres.add char2
			@caracteres.add char3

			@delante[char1].merge [char2,char3]
			@delante[char2].add char3

			@detras[char3].merge [char1,char2]
			@detras[char2].add char1

		end

		copiaCaracteres = Set.new(@caracteres)

		while not @caracteres.empty?

			completarSetsDelante(@caracteres.first)

		end

		if copiaCaracteres.empty?
			raise("NO se copia bien");
		end

		@caracteres = Set.new(copiaCaracteres)

		while not @caracteres.empty?

			completarSetsDetras(@caracteres.first)

		end

		temp = Array.new
		@caracteres = Set.new(copiaCaracteres)

		@caracteres.each do |c|
			if @detras[c].empty?
				temp << c
			end
		end

		lengthDelante = Hash.new
		lengthDetras = Hash.new

		@caracteres.each do |c|
			lengthDelante[c] = @delante[c].length
			lengthDetras[c] = @detras[c].length
		end

		max = temp.max { |x,y| lengthDelante[x] <=> lengthDelante[y] }

		tempA = Array.new
		hash = @delante[max].classify { |x| lengthDelante[x] }
		tempA << max
		hash.each do |key,ele|
			tempA << ele.first
		end

		inicial = Array.new
		tempA.sort! { |x,y| lengthDelante[y] <=> lengthDelante[x] }
		tempA.each do |ele|
			add = true
			inicial.each do |e|
				if not @detras[ele].include? e
					add = false
				end
			end
			if add
				inicial << ele
			end
		end

		#inicial = inicial.to_a.sort { |x,y| lengthDelante[y] <=> lengthDelante[x] }
		@caracteres.subtract inicial
		inicial.each_with_index do |c,index|
			inicial[index] = c.chr
		end 
		inicial = inicial.join("")

		@passwords = Array.new
		@passwords << inicial

		while not @caracteres.empty?

			char = @caracteres.first

			addChar(char, @detras[char], @delante[char])

			@caracteres.delete(char)

		end

		puts @passwords.sort.join("\n")


	end

	def completarSetsDelante(caracter)

		if @caracteres.include? caracter

			merged = Array.new

			@delante[caracter].each do |char|

				completarSetsDelante(char)
				merged << char

			end

			merged.each do |m|
				@delante[caracter].merge @delante[m]
			end

			@caracteres.delete caracter

		end

	end

	def completarSetsDetras(caracter)

		if @caracteres.include? caracter

			merged = Array.new

			@detras[caracter].each do |char|

				completarSetsDelante(char)
				merged << char

			end

			merged.each do |m|
				@detras[caracter].merge @detras[m]
			end

			@caracteres.delete caracter

		end

	end






#Metodo antiguo usando expresiones regulares y arrays infinitos con todas las posibilidades. Se comia toda la ram.
#Previous method. It used regexps and almost infinite arrays, making the algorithm eat all the ram.
=begin
	def hackear()

		@passwords=Array.new

		line=gets.chomp
		@passwords << line

		while line=gets

			char1=line[0]
			char2=line[1]
			char3=line[2]
			isChar1=@passwords[0].include?(char1)
			isChar2=@passwords[0].include?(char2)
			isChar3=@passwords[0].include?(char3)

			count=0

			if @passwords[0].include?(char1)
				isChar1 = true
				count += 1
			end

			if @passwords[0].include?(char2)
				isChar2 = true
				count += 1
			end

			if @passwords[0].include?(char3)
				isChar3 = true
				count += 1
			end

			#Si ya tengo todos los caracteres
			if count == 3

				#borro las que no cumplam la regexp
				matchPasswords("[a-zA-Z0-9]*#{char1}[a-zA-Z0-9]*#{char2}[a-zA-Z0-9]*#{char3}[a-zA-Z0-9]*")

			#Si ya tengo 2
			elsif count == 2

				#si falta la primera
				if not isChar1
					#regexp de las dos ultimas
					matchPasswords("[a-zA-Z0-9]*#{char2}[a-zA-Z0-9]*#{char3}[a-zA-Z0-9]*")
					#inserto hasta la ocurrencia de la del medio
					addChar(char1,nil,char2)

				#si falta la segunda
				elsif not isChar2
					#regexp de las dos de los extremos
					matchPasswords("[a-zA-Z0-9]*#{char1}[a-zA-Z0-9]*#{char3}[a-zA-Z0-9]*")
					#inserto desde la aparicion de la primera hasta la aparicion de la ultima
					addChar(char2,char1,char3)

				#si falta la tercera
				elsif not isChar3
					#regexp de las dos primeras
					matchPasswords("[a-zA-Z0-9]*#{char1}[a-zA-Z0-9]*#{char2}[a-zA-Z0-9]*")
					#inserto desde la aparicion de la segunda
					addChar(char3,char2,nil)

				end


			#si ya tengo 1
			elsif count == 1

				#si es la 1
				if isChar1
					#inserta la segunda desde la primera
					addChar(char2,char1,nil)
					#inserta la tercera desde la segunda
					addChar(char3,char2,nil)

				#si es la 2
				elsif isChar2
					#inserta la primera hasta la segunda
					addChar(char1,nil,char2)
					#inserta la tercera desde la segunda
					addChar(char3,char2,nil)

				#si es la 3
				else
					#inserta la segunda hasta la tercera
					addChar(char2,nil,char3)
					#inserta la primera hasta la segunda
					addChar(char1,nil,char2)
				end

			#si no tengo ninguna
			else

				#inserta la primera
				addChar(char1,nil,nil)
				#inserta la segunda desde la primera
				addChar(char2,char1,nil)
				#inserta la tercera desde la segunda
				addChar(char3,char2,nil)

			#acabose
			end

		end

		puts @passwords.sort.join("\n")

	end

	def matchPasswords(regexp)
		regexp=Regexp.new(regexp)
		@passwords.delete_if { |pass| ( pass =~ regexp ) == nil }
	end

=end

	def addChar(char,from,to)

		newPasswords=Array.new

		@passwords.each do |oldPass|

			if from == nil
				fromI = -1
			else
				fromI = -1
				from.each do |f|
					temp = oldPass.index(f.chr)
					if temp != nil and temp > fromI
						fromI = temp
					end
				end
			end

			if to == nil
				toI = oldPass.length
			else
				toI = oldPass.length
				to.each do |t|
					temp = oldPass.index(t.chr)
					if temp != nil and temp < toI
						toI = temp
					end
				end
			end

			(toI-fromI).times do |n|

				if fromI+n == -1
					primero = ""
				else
					primero = oldPass[0..(fromI+n)]
				end

				newPasswords << primero + char.chr + oldPass[(fromI+n+1)..-1] 

			end

		end

		@passwords = newPasswords

	end


end

PasswordCracker.new.hackear



