class String

	def isUpCase?
		if self.upcase == self
			return true
		else
			return false
		end
	end

	def isNumber?
		if self.to_i.to_s == self
			return true
		else
			return false
		end
	end

	def isSpace?
		if self == " "
			return true
		else
			return false
		end
	end

	def isTypable?
		if ("a".."z").include?(self) || ("A".."Z").include?(self) || ("0".."9").include?(self) || self == " "
			return true
		else
			return false
		end
	end

end

class Message

	VALUE_OF_A = "a"[0]
	KEY_TIME = 100
	WAIT_TIME = 500
	OB_TIME = 350
	H_TIME = 200
	V_TIME = 300

	def initialize(string)

		@actual_position = 10
		@block=false
		@sms = string

	end

	def keyOfCharacter(character)

		if character == "block"
			return 11
		end

		value = character.downcase[0] - VALUE_OF_A

		if value < 0 

			if character.isNumber?
				if character.to_i == 0
					return 10
				else
					return character.to_i - 1
				end
			end

			if character.isSpace?
				return 0
			end

		elsif value > 21

			return 8

		elsif value > 18

			return 7

		elsif value > 14

			return 6

		else

			return value/3 + 1

		end

	end

	def timeWriting(character)

		value = character.downcase[0] - VALUE_OF_A

		if value < 0 

			if character.isNumber?

				numero = character.to_i
				case numero

					when 0
						return 1*KEY_TIME
					when 7
						return 5*KEY_TIME
					when 9
						return 5*KEY_TIME
					else
						return 4*KEY_TIME
					end
			end

			if character.isSpace?
				return 1*KEY_TIME
			end

		elsif value > 21

			return ((value-22)%4+1)*KEY_TIME

		elsif value > 18

			return ((value-19)%3+1)*KEY_TIME

		elsif value > 14

			return ((value-15)%4+1)*KEY_TIME

		else

			return (value%3 + 1)*KEY_TIME

		end

	end

	def move(to)

		fromK = @actual_position

		result = 0

		toK=keyOfCharacter(to)

		if(fromK==toK)
			return WAIT_TIME
		end

		hDistance = fromK%3 - toK%3
		vDistance = fromK/3 - toK/3

		while hDistance!=0 or vDistance!=0

			hMove=0
			vMove=0
			
			if hDistance != 0
				if hDistance < 0
					hMove = 1
				else
					hMove = -1
				end
			end
			if vDistance != 0
				if vDistance < 0
					vMove = 1
				else
					vMove = -1
				end
			end

			if hMove!=0 and vMove!=0
				result += OB_TIME
			elsif hMove!=0
				result += H_TIME
			else
				result += V_TIME
			end

			hDistance += hMove
			vDistance += vMove 
		end

		@actual_position=toK

		return result

	end

	def timeSMS()

		result = 0

		@sms.split("").each do |char|

			if (char.isTypable?)

				if ( char.isUpCase? != @block ) and (!char.isNumber?) and (!char.isSpace?)
					result += move("block")
					@block = !@block
					result += KEY_TIME
				end

				result += move(char)
				result += timeWriting(char)

			end

		end

		return result

	end

end



=begin

def pruebasKey
	text=Message.new("hola")
	puts text.keyOfCharacter("A") == 1
	puts text.keyOfCharacter("B") == 1
	puts text.keyOfCharacter("C") == 1
	puts text.keyOfCharacter("D") == 2
	puts text.keyOfCharacter("e") == 2
	puts text.keyOfCharacter("2") == 1
	puts text.keyOfCharacter(" ") == 0
	puts text.keyOfCharacter("s") == 6

	puts text.timeWriting("a") == 100
	puts text.timeWriting("b") == 200
	puts text.timeWriting("A") == 100
	puts text.timeWriting("c") == 300
	puts text.timeWriting("d") == 100
	puts text.timeWriting("e") == 200
	puts text.timeWriting(" ") == 100
	puts text.timeWriting("s") == 400
	puts text.timeWriting("y") == 300
	puts text.timeWriting("z") == 400
	puts text.timeWriting("0") == 100
	puts text.timeWriting("7") == 500
	puts text.timeWriting("5") == 400
end 

pruebasKey

text=Message.new("tu")

puts text.timeSMS

=end


number=gets.chomp.to_i

number.times do
	line = gets.chomp
	puts Message.new(line).timeSMS

end



