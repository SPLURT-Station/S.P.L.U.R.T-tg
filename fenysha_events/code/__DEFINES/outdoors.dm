/proc/daytimeDiff(timeA, timeB)
	var/time_diff = timeA > timeB ? (timeB + 24 HOURS) - timeA : timeB - timeA
	return time_diff / SSticker.station_time_rate_multiplier
