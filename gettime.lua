function gettime()
	t = os.date("!*t")
	return math.floor(((t.hour+1)*3600+t.min*60+t.sec)/86.4)
end

