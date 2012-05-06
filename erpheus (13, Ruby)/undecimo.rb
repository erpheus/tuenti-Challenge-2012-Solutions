require 'set'

class DictionaryPreprocessor

	attr_accessor(:maxValue)

	def initialize(fileName)

		@file=File.new("undecimo/"+fileName,"r")

	end

	def generatePunctuationFiles(sufix)

		files=Array.new
		max = 0

		while line=@file.gets

			line.chomp!

			value=line.valueOfWord
			if value > max
				max = value
			end

			if files[value] == nil
				files[value] = File.new("undecimo/"+value.to_s+sufix,"w")
			end

			files[value].puts line

		end
		@maxValue = max

		files.each do |f|
			unless not f
				f.close
			end
		end

		return self
	end

	def addNumbers(sufix,previousSufix)

		@maxValue.times do |n|
			if File.exists?("undecimo/"+(n+1).to_s+previousSufix)
				addNumbersToFile((n+1).to_s,sufix,previousSufix)
			end
		end

		return self

	end

	def addNumbersToFile(name,sufix,previousSufix)

		oldFile=File.new("undecimo/"+name+previousSufix,"r")
		newFile=File.new("undecimo/"+name+sufix,"w")

		sameCharacter=Array.new
		actChar="Z"

		line=oldFile.gets
		unless line == nil
			actChar = line[0]
			sameCharacter << line
		end

		while line=oldFile.gets
			line.chomp!
			if line[0] == actChar
				sameCharacter << line
			else
				newFile.puts sameCharacter.length.to_s + " " + actChar
				sameCharacter.each do |word|
					newFile.puts word
				end
				sameCharacter=Array.new()
				sameCharacter << line
				actChar = line[0]
			end
		end
		newFile.puts sameCharacter.length.to_s + " " + actChar
		sameCharacter.each do |word|
			newFile.puts word
		end

		oldFile.close
		newFile.close
	end

end

class String

	DIFF = "A"[0].ord
	VALORES = [1,3,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10]

	def valueOfWord

		result=0

		self.each_byte do |char|

			result+=VALORES[char-DIFF]

		end

		return result

	end

	def maxPossibleValue

		max = 0

		self.each_byte do |char|

			temp=VALORES[char-DIFF]
			if temp>max
				max = temp
			end

		end

		return max

	end
end

#max = DictionaryPreprocessor.new("descrambler_wordlist.txt").generatePunctuationFiles("temp").addNumbers("","temp").maxValue
max = 57

class Scrabble
	def initialize(bestValue)
		@values=Array.new
		bestValue.times do |n|
			if File.exists?("undecimo/"+(n+1).to_s)
				@values << n+1
			end
		end
		@posibleCharacters = Set.new
	end

	def reset
		@posibleCharacters=Set.new
	end

	def setHword(word)
		@word = Set.new(word.split(""))
		@posibleCharacters.merge word.split("")
		@maxWordValue=word.maxPossibleValue
	end

	def setRack(characters)
		@rack=Hash.new(0)
		@rackLength=0
		characters.each_char do |char|
			@rack[char]+= 1
			@rackLength+=1
		end
		@rackLength += 1
		@posibleCharacters.merge characters.split("")
		@maxRackValue=characters.valueOfWord
	end

	def bestMove()
		limit = @maxRackValue+@maxWordValue+1
		limit.times do |n|
			name = (limit-n).to_s
			if File.exists?("undecimo/"+name)
				best = checkFile(name)
				if best
					return best + " " + name
				end
			end
		end
		return ""
	end

	def checkFile(name)

		file = File.new("undecimo/"+name,"r")

		while line = file.gets
			line = line.split(" ")
			actualCharacter = line[1]
			numberOfLines = line[0].to_i

			if not @posibleCharacters.include? actualCharacter
				numberOfLines.times do
					file.gets
				end
			else
				numberOfLines.times do
					line = file.gets.chomp
					if wordPossible?(line)
						return line
					end
				end
			end
		end

		return nil

	end


	def wordPossible?(word)

		if word.length > @rackLength
			return false
		end

		usedPrevious = false
		tempRack = @rack.clone

		word.each_char do |char|

			if tempRack[char] == 0

				if not usedPrevious and @word.include? char
					usedPrevious=true
				else
					return false
				end

			else
				tempRack[char] -= 1
			end

		end

		if not usedPrevious

			word.each_char do |char|

				if @word.include? char

					return true
				end
			end

			return false
		end

		return true

	end

end

game=Scrabble.new(max)

number=gets.chomp.to_i

number.times do

	line=gets.chomp.split(" ")
	game.reset
	game.setRack(line[0])
	game.setHword(line[1])
	puts game.bestMove

end













