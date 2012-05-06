
class String
	def nibbleWiseSum(other)

		result = ""

		self.split("").each_with_index do |char,index|
			num1 = char.to_i(16)
			num2 = other[index].to_i(16)
			result += ((num1+num2)%16).to_s(16)
		end

		return result
	end
end


keyTextComment = "a541714a17804ac281e6ddda5b707952" #obtained with notepad
keyLSB = "62cd275989e78ee56a81f0265a87562e" #obtained by hand looking at the HEX value of each pixel with photoshop's eyedropper and writing down LSBs
keyQR = "ed8ce15da9b7b5e2ee70634cc235e363" #obtained by resizing, clearing and inverting image on photoshop

dato = gets.chomp

puts keyLSB.nibbleWiseSum( keyTextComment.nibbleWiseSum( keyQR.nibbleWiseSum( dato ) ) )


