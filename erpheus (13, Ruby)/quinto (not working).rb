require 'Time'
require 'Date'

class GoodClock

	GOOD_BASE_10 = [1,0,4,1,1,2,1,1,4,0]
	GOOD_BASE_6 = [2,0,4,1,1,2]
	GOOD_BASE_24 = [4,0,4,1,1,2,1,1,4,0,1,0,4,1,1,2,1,1,4,0,5,0,4,1]

	MINUTE=100
	HOUR=6100
	DAY=146443

	def oneMinute()
		result = 6 * GOOD_BASE_10.inject(:+)
		result += GOOD_BASE_6.inject(:+)
		return result
	end

	def oneHour(minute)
		result = minute + minute*60
		return result
	end

	def oneDay(hour)
		result = 24 * hour
		result += GOOD_BASE_24.inject(:+)
		return result
	end

	def fromSecondtoNext(second,minute,hour)
		nextOne = (second+1)%60
		result = GOOD_BASE_10[nextOne%10]
		if nextOne % 10 == 0
			result += GOOD_BASE_6[nextOne/10]
		end
		nextMinute=minute
		if nextOne == 0
			nextMinute = (minute+1)%60
			result += GOOD_BASE_10[nextMinute%10]
			if nextMinute%10 == 0
				result += GOOD_BASE_6[nextMinute/10]
			end
			if nextMinute == 0
				nextHour = (hour+1)%24
				result += GOOD_BASE_24[nextHour]
			end
		end
		return result
	end

	def fromMinutetoNext(minute,hour)
		result=MINUTE
		nextMinute = (minute+1)%60
		result += GOOD_BASE_10[nextMinute%10]
		if nextMinute%10 == 0
			result += GOOD_BASE_6[nextMinute/10]
		end
		if nextMinute == 0
			nextHour = (hour+1)%24
			result += GOOD_BASE_24[nextHour]
		end
		return result
	end

	def fromHourtoNext (hour)
		result = HOUR
		nextHour = (hour+1)%24
		result += GOOD_BASE_24[nextHour]
		return result
	end

end

class BadClock

	BAD = [6,2,5,5,4,5,6,3,7,6]
	BAD_24 = [12,8,11,11,10,11,12,9,13,12,8,4,7,7,6,7,8,5,9,8,11,7,10,10]
	MINUTE = 564 #calculated with oneMinute()
	HOUR = 67680 #calculated with oneHour()
	DAY = 2401920 #calculated with oneDay()

	def initialize()

	end

	def oneMinute()

		result = 6 * BAD.inject(:+)
		result += 10 * BAD.slice(0,6).inject(:+)
		return result
	end

	def oneHour(minute)

		result = 60 * minute
		result += 60 * minute
		return result
	end

	def oneDay(hour)
		result = 3600 * BAD_24.inject(:+)  
		result += 24 * hour
		return result
	end

	def fromSecondtoNext(second,minute,hour)
		nextOne = (second+1)%60
		result = BAD[nextOne%10] + BAD[nextOne/10]
		newMinute = minute
		newHour = hour
		if nextOne == 0
			newMinute = (minute+1)%60
			if newMinute == 0
				newHour = (hour+1)%24
			end
		end
		result += BAD[newMinute%10] + BAD[newMinute/10]
		result += BAD[newHour%10] + BAD[newHour/10]
		return result
	end

	def fromMinutetoNext(second,minute,hour)
		result=MINUTE
		cuantasVecesPrimero=59-second
		cuantasVecesSegundo=60-cuantasVecesPrimero

		result += cuantasVecesPrimero*( BAD[minute%10] + BAD[minute/10] )
		nextMinute = (minute+1)%60
		result += cuantasVecesSegundo*( BAD[nextMinute%10] + BAD[nextMinute/10])

		if nextMinute==0
			result += cuantasVecesPrimero*( BAD_24[hour] )
			nextHour = (hour+1)%24
			result += cuantasVecesSegundo*( BAD_24[nextHour])
		end
		return result
	end

	def fromHourtoNext(minute,hour)
		result = HOUR
		cuantasVecesPrimero=59-minute
		cuantasVecesSegundo=60-cuantasVecesPrimero
		result += cuantasVecesPrimero*(BAD_24[hour])
		nextHour = (hour+1)%24
		result += cuantasVecesSegundo*(BAD_24[nextHour])
		return result
	end


end

def diferencia(desde,hasta)

	bad=BadClock.new
	good=GoodClock.new

	desdeDate = desde.split(" ")[0]
	hastaDate = hasta.split(" ")[0]
	desdeTime = desde.split(" ")[1].split(":")
	hastaTime = hasta.split(" ")[1].split(":")

	desdeDate = Date.strptime(desdeDate, "%Y-%m-%d")
	hastaDate = Date.strptime(hastaDate, "%Y-%m-%d")

	desdeHour = desdeTime[0].to_i
	desdeMin = desdeTime[1].to_i
	desdeSec = desdeTime[2].to_i

	hastaHour = hastaTime[0].to_i
	hastaMin = hastaTime[1].to_i
	hastaSec = hastaTime[2].to_i

	diferencia=0

	while desdeSec != hastaSec

		diferencia += bad.fromSecondtoNext(desdeSec,desdeMin,desdeHour) - good.fromSecondtoNext(desdeSec,desdeMin,desdeHour)
		desdeSec = (desdeSec+1)%60
		if desdeSec == 0
			desdeMin = (desdeMin + 1)%60
			if desdeMin == 0
				desdeHour = (desdeHour + 1)%24
				if desdeHour == 0
					desdeDate = desdeDate + 1
				end
			end
		end

	end

	while desdeMin != hastaMin 

		diferencia += bad.fromMinutetoNext(desdeSec,desdeMin,desdeHour) - good.fromMinutetoNext(desdeMin,desdeHour)
		desdeMin = (desdeMin + 1)%60
		if desdeMin == 0
			desdeHour = (desdeHour + 1)%24
			if desdeHour == 0
				desdeDate = desdeDate + 1
			end
		end
	end

	while desdeHour != hastaHour

		diferencia += bad.fromHourtoNext(desdeMin,desdeHour) - good.fromHourtoNext(desdeHour)

		desdeHour = (desdeHour+1)%24
		if desdeHour == 0
			desdeDate = desdeDate + 1
		end

	end

	days = hastaDate - desdeDate
	diferencia += BadClock::DAY * days
	diferencia -= GoodClock::DAY * days

	return diferencia

end


#while(line=gets)
#	line=line.chomp
	line="2012-01-07 00:00:00 - 2012-01-13 00:18:13"
	rango=line.split(" - ")
	puts diferencia(rango[0],rango[1])
#end



