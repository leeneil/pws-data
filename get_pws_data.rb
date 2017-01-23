require "open-uri"

# pws_id = "KCAPALOA15"
pws_id = "KCASTANF13"
year_start = 2016
mon_start = 12
day_start = 1
year_end = 2017
mon_end = 1
day_end = 22

dir_name = pws_id + "_data/"
Dir.mkdir(dir_name) unless Dir.exist?(dir_name)

for year in year_start..year_end
	if year == year_start
		mon_a = mon_start
	else
		mon_a = 1
	end
	if year == year_end
		mon_b = mon_end
	else
		mon_b = 12
	end
	mons = mon_a..mon_b

	dir_name = pws_id + "_data/" + year.to_s + '/'
	Dir.mkdir(dir_name) unless Dir.exist?(dir_name)


	for mon in mons
		if year == year_start and mon == mon_start
			day_a = day_start
		else
			day_a = 1
		end
		if year == year_end and mon == mon_end
			day_b = day_end
		else
			case mon
			when 1, 3, 5, 7, 8, 10, 12
				day_b = 31
			when 4, 6, 9, 11
				day_b = 30
			else
				if year == 2016 or year == 2012
					day_b = 29
				else
					day_b = 28
				end
			end
		end
		days = day_a..day_b
		for day in days
			d = Date.new(year, mon, day)
			url = "https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=#{pws_id}&day=#{day.to_s}&month=#{mon.to_s}&year=#{year.to_s}&graphspan=day&format=1"
			filename = d.strftime("%Y%m%d") + ".csv"
			puts filename
			open(dir_name + filename, "wb") do |file|
				file << open(url).read.gsub("\nTime","Time").gsub("DateUTC<br>","DateUTC").gsub("<br>\n","")
			end
		end
	end
end


