require "open-uri"
require "csv"

pws_id = "KCAPALOA15"

year_start = 2009
mon_start = 7
day_start = 7
year_end = 2017
mon_end = 1
day_end = 21

dir_name = pws_id + "_data/"

features = []
counter = 0

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
			filename = d.strftime("%Y%m%d") + ".csv"
			puts filename
			data = CSV.read(dir_name + filename, :headers=>:first_row, :skip_blanks=>true)
			sta = []
			for line in data
				# puts line[0]
				t = Time.parse(line[0])
				if sta[ t.hour ].nil?
					sta[ t.hour ] = [0,0,0,0,0]
				end
				sta[ t.hour ][0] = sta[ t.hour ][0] + (line[1].to_f-32.0)/1.8 # temperatureF
				sta[ t.hour ][1] = sta[ t.hour ][1] + (line[3].to_f) # pressureIn
				sta[ t.hour ][2] = sta[ t.hour ][2] + line[8].to_f # humidity
				sta[ t.hour ][3] = sta[ t.hour ][3] + line[9].to_f # HourlyPrecipIn
				sta[ t.hour ][4] = sta[ t.hour ][4] + 1

			end
			puts "counter = " + counter.to_s
			features[counter] = []
			# puts "vvvv"
			# puts sta
			# puts "^^^"
			checker = 0
			for s in sta
				if s.nil?
					features[counter] << 0
					features[counter] << 0
					features[counter] << 0
					features[counter] << 0
				else
					features[counter] << s[0] / s[4]
					features[counter] << s[1] / s[4]
					features[counter] << s[2] / s[4]
					features[counter] << s[3] / s[4]
				end
				checker = checker + 1
			end
			# puts features[counter]
			if checker == 24
				counter = counter + 1
			else
				puts d
				puts "only has " + checker.to_s + " data. skipped."
			end
		end
	end
end

CSV.open(pws_id+"_features.csv",'wb') do |csv|
	for line in features
		csv << line
	end
end

