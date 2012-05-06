require 'digest/md5'

class CloningSpree
	
	def readInput

		@rounds=Array.new
		initial = gets.chomp
		@lookup = Array.new

		while line=gets

			line=line.chomp

			hash = Hash.new
			lookupHash = Hash.new

			transformations = line.split(",")

			transformations.each do |transformation|

				transformation = transformation.split("=>")

				hash[transformation[0]] = transformation[1]

			end

			@rounds << hash
			@lookup << lookupHash

		end

		@numLevels=@rounds.length
		@md5 = Digest::MD5.new()

		@buffer = ""

		@maxLevel = @rounds.length

		initial.each_char do |char|

			result = @lookup[0][char]

			if result == nil

				@buffer = ""
				expand(char,0)
				@lookup[0][char] = @buffer
				@md5.update(@buffer)

			else

				@md5.update(result)

			end

		end

		#puts @buffer

		puts @md5.hexdigest

	end

	def expand(char,level)

		if level == @maxLevel

			@buffer += char

		else

			change = @rounds[level][char]

			if change == nil

				buffercopy = @buffer
				@buffer=""

				unless level+1 == @maxLevel
					result = @lookup[level+1][char]
				end
				
				if level+1 == @maxLevel or result == nil

					expand(char,level+1)
					unless level+1 == @maxLevel
						@lookup[level+1][char]=@buffer
					end

				else
					@buffer = result
				end

				@buffer = buffercopy + @buffer

			else

				change.each_char do |c|

					buffercopy = @buffer
					@buffer = ""

					unless level+1 == @maxLevel
						result = @lookup[level+1][c]
					end

					if level+1 == @maxLevel or result == nil

						expand(c,level+1)
						unless level+1 == @maxLevel
							@lookup[level+1][c] = @buffer
						end

					else
						@buffer = result
					end

					@buffer = buffercopy + @buffer

				end
			end

		end
	end

end

CloningSpree.new.readInput

