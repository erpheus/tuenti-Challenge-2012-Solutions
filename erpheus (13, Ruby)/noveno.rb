buscadosArray = Array.new
buscados = Hash.new
encontrados=Hash.new

cantidad = gets.chomp.to_i

cantidad.times do
	line = gets.chomp.split(" ")
	buscados[line[0]] = line[1]
	buscadosArray << line[0]
end

numFile = 1

while cantidad != 0 and numFile <= 800

	if numFile < 10
		fileName = "documents/000" + numFile.to_s
	elsif n < 100
		fileName = "documents/00" + numFile.to_s
	else
		fileName = "documents/0" + numFile.to_s
	end

	file = File.new(fileName,"r")

	numLine=1

	while line=file.gets

		array = line.chomp.split(" ")

		numWord = 1

		array.each do |word|

			if buscados.key? word

				result = buscados[word]
				if result != nil
					if result <= 1
						encontrados[word] = numFile.to_s+"-"+numLine.to_s+"-"+numWord.to_s
						buscados[word] = 0
						cantidad -= 1
					else
						buscados[word] = result - 1
					end
				end

			end

			numWord+=1
		end

		numLine+=1

	end

	file.close

	numFile+=1

end

buscadosArray.each do |buscado|
	puts encontrados[buscado]
end
