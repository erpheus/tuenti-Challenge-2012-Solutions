
require 'rational'
require 'set'

def movesUntilequal(totalCards,l)

	secondCards=totalCards-l

	visited=Set.new
	max = 1

	totalCards.times do |n|

		start = n+1
		pos = start

		times = 0

		if not visited.include? start

			begin

				if pos <= secondCards

					if pos <= l
						pos = 2*pos
					else
						pos = l+pos
					end
				else
					if pos <= 2*secondCards
						pos = 2*(pos- secondCards ) - 1
					end
				end


				pos = totalCards+1 - pos
				visited.add pos

				times += 1

			end while pos != start

			max = max.lcm times

		end
	end

	return max

end

number=gets.chomp.to_i

number.times do |n|
	line = gets.chomp.split(" ")
	puts "Case \##{n+1}: "+(movesUntilequal(line[0].to_i,line[1].to_i)).to_s
end

