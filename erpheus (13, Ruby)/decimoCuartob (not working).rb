
require 'matrix'

def resultado(vector)

	contador=0
	while vector.length != 35
		vector << 0
		contador += 1
	end

	h = Matrix[[0,0,0,0,1,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,1,0,1,1,1,0,1,1,1,0],[0,1,1,1,0,0,0,1,1,0,1,1,1,0,1,1,1,1,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0],[1,0,0,0,1,1,0,1,0,0,0,1,0,0,0,1,0,0,1,1,0,1,1,1,0,1,1,1,1,1,0,0,1,1,1],[0,0,1,0,0,1,0,1,1,0,0,0,1,0,0,1,0,0,1,1,1,0,1,0,1,0,0,0,1,1,0,1,0,0,0]]

	x = Matrix.column_vector(vector)

	res = (h*x).to_a

	res.each_with_index do |char,index|
		temp=(char.to_s.to_i%2).to_s
		if temp=="1"
			if vector[index]==1
				vector[index]=0
			else
				vector[index]=1
			end
		end
		res[index]=temp
	end

	result = ""
	vector.each do |whatever|
		result += whatever.to_s
	end

	return result[0..(vector.length-contador)]

end

while line=gets
	line.chomp!
	result=""
	actual=0
	vector=Array.new

	line.each_char do |char|
		if actual == 35
			result += resultado(vector)
			vector = Array.new
			vector << char.to_i
			actual=1
		else
			vector << char.to_i
			actual += 1
		end
	end

	result += resultado(vector)

	puts result

end

